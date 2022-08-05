#!/usr/bin/bash -l

set -e
module purge
module load nvhpc-nompi/21.7
module load openmpi/openmpi-4.1.4_ucx-1.12.1_nvhpc-21.7


cd $HOME
git clone https://github.com/HDFGroup/hdf5.git || true
cd hdf5
git checkout hdf5-1_12_2
make clean || true

# CC, F90, CXX, F77 set by OpenMPI + UCX module
FC=$F90 CC=$CC RUNPARALLEL='/lus/theta-fs0/software/thetagpu/openmpi/openmpi-4.1.4_ucx-1.12.1_nvhpc-21.7/bin/mpiexec -n $${NPROCS:=6}' RUNSERIAL='/lus/theta-fs0/software/thetagpu/openmpi/openmpi-4.1.4_ucx-1.12.1_nvhpc-21.7/bin/mpiexec -n 1' ./configure --enable-parallel --prefix=/lus/theta-fs0/software/thetagpu/hdf5/1.12.2-nvhpc/ --enable-fortran --with-zlib=yes FCFLAGS=-fPIC

make -j128 V=1 |& tee log

#make check
export UCX_LOG_LEVEL=error
make check-p
make install
