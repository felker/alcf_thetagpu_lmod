#!/usr/bin/bash -l

set -e
module purge
module load nvhpc-nompi/21.7
module load openmpi/openmpi-4.1.4_ucx-1.12.1_nvhpc-21.7


cd $HOME
# KGF: best to rm -rfd the whole directory after failed builds. Had trouble building 1.12.2 when reusing earlier 1.8.x build directory:
# Making all in test
# make[1]: Entering directory '/home/felker/hdf5/test'
# make[1]: *** No rule to make target '../src/H5HGpublic.h', needed by 'gheap.o'.  Stop.
git clone https://github.com/HDFGroup/hdf5.git || true
cd hdf5
git checkout hdf5-1_12_2
# git checkout hdf5-1_13_1
make clean || true

# CC, F90, CXX, F77 set by OpenMPI + UCX module
FC=$F90 CXX=$CXX CC=$CC RUNPARALLEL='/lus/theta-fs0/software/thetagpu/openmpi/openmpi-4.1.4_ucx-1.12.1_nvhpc-21.7/bin/mpiexec -n $${NPROCS:=6}' RUNSERIAL='/lus/theta-fs0/software/thetagpu/openmpi/openmpi-4.1.4_ucx-1.12.1_nvhpc-21.7/bin/mpiexec -n 1' ./configure --enable-parallel --enable-fortran --with-zlib=yes FCFLAGS=-fPIC --prefix=/lus/theta-fs0/software/thetagpu/hdf5/1.12.2-nvhpc/
# --prefix=/lus/theta-fs0/software/thetagpu/hdf5/1.13.1-nvhpc/

# Huihuo's additional flags:
#  --enable-symbols=yes --enable-build-mode=production --enable-unsupported --enable-threadsafe

make -j128 V=1 |& tee log

#make check
export UCX_LOG_LEVEL=error
make check-p
make install
