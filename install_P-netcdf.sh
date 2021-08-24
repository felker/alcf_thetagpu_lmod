#!/usr/bin/env bash

set -e
#H5DIR=/lus/theta-fs0/software/thetagpu/hdf5/1.12.0
H5DIR=/lus/theta-fs0/software/thetagpu/hdf5/1.8.22
NCDIR=/lus/theta-fs0/software/thetagpu/netcdf
NFDIR=/lus/theta-fs0/software/thetagpu/netcdf

mkdir -p ${NCDIR}
mkdir -p ${NFDIR}

#module load hdf5/1.12.0
module load hdf5/1.8.22

# NetCDF C library 4.8.0 = released 2021-04-02

cd /lus/theta-fs0/software/thetagpu/netcdf
git clone https://github.com/Unidata/netcdf-c.git
cd netcdf-c
git checkout v4.8.0
make clean

# https://www.unidata.ucar.edu/software/netcdf/documentation/NUG/getting_and_building_netcdf.html
./bootstrap  # requires automake and autoconf

#CPPFLAGS="-DH5_USE_110_API -I${H5DIR}/include" LDFLAGS=-L${H5DIR}/lib CC=mpicc ./configure --enable-parallel-tests --prefix=${NCDIR}  # --disable-shared

CPPFLAGS="-I${H5DIR}/include" LDFLAGS=-L${H5DIR}/lib CC=mpicc ./configure --enable-parallel-tests --prefix=${NCDIR} --disable-dap

# KGF: disabling remote access protocol to eliminate dependency on libcurl (curl.h not found, even though /usr/bin/curl exists)

# NetCDF 4.8.0 supports HDF5 1.8.9+ and 1.10.1+ HDF5 minor release series
# "When building netCDF-C library versions older than 4.4.1, use only HDF5 1.8.x versions"

# fix for HDF5 1.12.0 not yet released
# https://github.com/Unidata/netcdf-c/pull/1980

# Cmake alternative:
#CPPFLAGS=-DH5_USE_110_API CC=mpicc cmake
make check
make install

cd /lus/theta-fs0/software/thetagpu/netcdf

# NetCDF-Fortran library 4.5.3 = released 2020-06-02
version_str=4.5.3

echo "Delete netcdf-fortran-${version_str} and v${version_str}.tar.gz ?"
rm -rdvI "netcdf-fortran-${version_str}/"
rm "v${version_str}.tar.gz"

wget https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v${version_str}.tar.gz
tar zxf v${version_str}.tar.gz
cd netcdf-fortran-${version_str}
make clean
# gcc, gfortran versions on ThetaGPU are 9.3.0. Once gcc-10 is used:
# https://github.com/Unidata/netcdf-fortran/issues/212
# export FCFLAGS="-w -fallow-argument-mismatch -O2"
# export FFLAGS="-w -fallow-argument-mismatch -O2"

# https://www.unidata.ucar.edu/software/netcdf/docs/building_netcdf_fortran.html
export LD_LIBRARY_PATH=${NCDIR}/lib:${LD_LIBRARY_PATH}
CC=mpicc FC=mpif90 CPPFLAGS="-I${NCDIR}/include -I${H5DIR}/include" LDFLAGS="-L${NCDIR}/lib -L${H5DIR}/lib" LIBS="-lnetcdf -lhdf5_hl -lhdf5 -lm -lz" LD_LIBRARY_PATH=${NCDIR}/lib:${H5DIR}/lib ./configure --prefix=${NFDIR} --disable-fortran-type-check # --disable-shared # -lcurl
make check
make install
