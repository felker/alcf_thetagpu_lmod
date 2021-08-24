#!/usr/bin/env bash

set -e
module purge
#  module unload openmpi/openmpi-4.0.5
# 4.0.5 should probably be the default build due to it's preference by the nvhpc folks
module use /lus/theta-fs0/software/environment/thetagpu/lmod/tmp
# KGF: Other UCX installs on ThetaGPU lead to UCX errors during ph5diff tests (and non-fatally can be generated during below UCX ./io_demo)
#  1629755187.401889] [thetagpu19:4178252:0]    ucp_context.c:1114 UCX  ERROR exceeded transports/devices limit (72 requested, up to 64 are supported)
module load openmpi-4.1.0_ucx-1.11.0_gcc-9.3.0
# https://github.com/openucx/ucx/issues/4842
# https://github.com/openucx/ucx/pull/4905/commits/f0b3901d3c3ca1b2e389bf15c4357986d80cc90e
# UCT_SOCKCM_PRIV_DATA_LEN extended to 2048 in March 2020, 1.9.0 and later

# https://github.com/openucx/ucx/issues/4557
# UCP_MAX_RESOURCES increased from 64 to 128 in Feb 2021 (1.11.0 and later)
# https://github.com/openucx/ucx/commit/728dda3bd6600f838b026dc76878d4c66ac3a1cd
# "64 is the limit due to a uint64_t var being used as a bitmap for resource usage. In 1.11.0, UCX also moved to using a custom type for the resource bitmap, definitely more effort put in than my cludgy, failed hack attempt last year"

# Earlier OpenMPI/UCX modules used Adam's incomplete hacks to workaround the transports/devices limit

# Modifying UCX_TLS via RUNPARALLEL in https://github.com/HDFGroup/hdf5/blob/develop/release_docs/INSTALL_parallel
# does not seem to work, nor does adding /home/felker/hdf5/bin/mpirun custom wrapper and modifying PATH

# could be the case the passing UCX_TLS a second time just isn't updating it

# for a single-node test I recommend keeping at least self and shm.
# if your test app uses gpus at all keep the 2 cuda transports as well
# and either add the transport you'd like to test(assume you're planning on trying sockcm and rdmacm), or add back one of the above transports one at a time and test each
# time consuming but it seriously beats looking through UCX traces(verbose to the point of worthlessness)

# cant find documentation for mm or cma (which I imagine is cross-memory attach) in https://openucx.readthedocs.io/en/master/faq.html?highlight=cuda_ipc#list-of-main-transports-and-aliases
# https://github.com/openucx/ucx/wiki/UCX-environment-parameters


# Unclear why ph5diff even reaches these limits (and UCX's io_test), since it often only invokes 1 or 6 MPI ranks
# Invoking ph5diff directly as below gives: "Only 1 task available...doing serial diff"

# These initial warnings still appear?
# --------------------------------------------------------------------------
# WARNING: There was an error initializing an OpenFabrics device.

#   Local host:   thetagpu19
#   Local device: mlx5_0
# --------------------------------------------------------------------------

cd $HOME
git clone https://github.com/HDFGroup/hdf5.git
cd hdf5
git checkout hdf5-1_8_22
make clean
CC=/lus/theta-fs0/software/thetagpu/openmpi/openmpi-4.1.0_ucx-1.11.0_gcc-9.3.0/bin/mpicc RUNPARALLEL='/lus/theta-fs0/software/thetagpu/openmpi/openmpi-4.1.0_ucx-1.11.0_gcc-9.3.0/bin/mpiexec -n $${NPROCS:=6}' RUNSERIAL='/lus/theta-fs0/software/thetagpu/openmpi/openmpi-4.1.0_ucx-1.11.0_gcc-9.3.0/bin/mpiexec -n 1' ./configure --enable-parallel --prefix=/lus/theta-fs0/software/thetagpu/hdf5/1.8.22/
# changing affinity in mpirun above with "--map-by node --bind-to numa" didnt circumvent the issues with the old modules
make -j128

# make check
# "UCX  WARN  unexpected tag-receive descriptor" occuring during MPI_Finalize() and the stderr is polluting the ph5diff test outputs w.r.t. the stored reference output, causing the test to fail. Suppress warnings:
# https://forum.hdfgroup.org/t/h5diffgentest-error/6115
export UCX_LOG_LEVEL=error
make check-p
make install

# https://stackoverflow.com/questions/66142470/ucx-warn-unexpected-tag-receive
# https://forum.hdfgroup.org/t/parallel-hdf5-test-failures-power9-lustre-openmpi-ucx/7752
# https://github.com/openucx/ucx/issues/6331


# https://github.com/openucx/ucx/wiki/Logging

# cd tools/h5diff/
# see testph5diff.sh.chklog

#### likely cannot invoke ph5diff directly from the build directory. Need to use libtool?
# cd testfiles
# ../ph5diff -v compounds_array_vlen1.h5 compounds_array_vlen2.h5
# ../ph5diff --lt-debug
# ../ph5diff --lt-dump-script

# See https://github.com/open-mpi/ompi/issues/7795
#  ../libtool --mode=execute mpirun -mca io ompio -n 6 ./testphdf5

# ph5diff: This wrapper script should never be moved out of the build directory.
# If it is, it will not operate correctly.


# KGF: need to find documentation on how to properly invoke the server and client processes of ucx_perftest
# https://github.com/openucx/ucx/issues/4557
# https://github.com/openucx/ucx/blob/master/contrib/test_jenkins.sh

# ucx_info -c
# ucx_perftest localhost -t put_lat -c 1 -n 10000 -x cuda_ipc -d cudaipc0 -s 1000000
# CUDA_VISIBLE_DEVICES=1 UCX_NET_DEVICES=rdma2 UCX_LOG_LEVEL=DEBUG UCX_NET_DEVICES=rdma2 UCX_TLS=sm,cuda_copy,cuda_ipc ucx_perftest 172.16.0.166 -m cuda -t tag_bw

# cd /lus/theta-fs0/software/thetagpu/ucx/ucx-1.11.0_gcc-9.3.0/bin
# ./io_demo
