#!/usr/bin/env bash

set -e
H5DIR=/lus/theta-fs0/software/thetagpu/hdf5/1.12.0
NCDIR=/lus/theta-fs0/software/thetagpu/netcdf
NFDIR=/lus/theta-fs0/software/thetagpu/netcdf

mkdir -P ${NCDIR}
mkdir -P ${NFDIR}

# NetCDF C library 4.8.0 = released 2021-04-02
# version_str=4.8.0
# echo "Delete netcdf-c-${version_str} and v${version_str}.tar.gz ?"
# rm -rdvI "netcdf-c-${version_str}/"
# rm "v${version_str}.tar.gz"
# wget https://github.com/Unidata/netcdf-c/archive/refs/tags/v${version_str}.tar.gz
# tar zxf v${version_str}.tar.gz
# cd netcdf-c-${version_str}
# make clean

cd /lus/theta-fs0/software/thetagpu/
git clone https://github.com/Unidata/netcdf-c.git
cd netcdf-c
./bootstrap  # requires automake and autoconf

# see install_P-hdf5.sh
CPPFLAGS="-DH5_USE_110_API -I${H5DIR}/include" LDFLAGS=-L${H5DIR}/lib CC=mpicc ./configure --disable-shared --enable-parallel-tests --prefix=${NCDIR}
# might require that HDF5 1.12.x be rebuilt with --with-default-api-version-v18
# https://github.com/Unidata/netcdf-c/issues/1978
# https://github.com/Unidata/netcdf-c/issues/1992
# https://support.hdfgroup.org/HDF5/doc/RM/APICompatMacros.html

# NetCDF 4.8.0 supports HDF5 1.8.9+ and 1.10.1+ HDF5 minor release series
# "When building netCDF-C library versions older than 4.4.1, use only HDF5 1.8.x versions"

# fix for HDF5 1.12.0 not yet released
# https://github.com/Unidata/netcdf-c/pull/1980

# Cmake alternative:
#CPPFLAGS=-DH5_USE_110_API CC=mpicc cmake
make check
make install

cd /lus/theta-fs0/software/thetagpu/

# NetCDF-Fortran library 4.5.3 = released 2020-06-02
version_str=4.5.3

echo "Delete netcdf-fortran-${version_str} and v${version_str}.tar.gz ?"
rm -rdvI "netcdf-fortran-${version_str}/"
rm "v${version_str}.tar.gz"

wget https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v${version_str}.tar.gz
tar zxf v${version_str}.tar.gz
cd netcdf-fortran-${version_str}
make clean
# https://github.com/Unidata/netcdf-fortran/issues/212
export FCFLAGS="-w -fallow-argument-mismatch -O2"
export FFLAGS="-w -fallow-argument-mismatch -O2"
# /usr/bin/curl library: https://developer.apple.com/forums/thread/655588
#ODIR=
# https://www.unidata.ucar.edu/software/netcdf/docs/building_netcdf_fortran.html
# for static builds
# should technically add -L${ODIR}/lib, /include, :${ODIR}/lib to next line
CC=mpicc FC=mpif90 CPPFLAGS="-I${NCDIR}/include -I${H5DIR}/include" LDFLAGS="-L${NCDIR}/lib -L${H5DIR}/lib" LIBS="-lnetcdf -lhdf5_hl -lhdf5 -lm -lz -lcurl" LD_LIBRARY_PATH=${NCDIR}/lib:${H5DIR}/lib ./configure --prefix=${NFDIR} --disable-fortran-type-check --disable-shared
make check
make install
