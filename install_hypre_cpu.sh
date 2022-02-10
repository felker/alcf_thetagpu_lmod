#!/bin/bash

cd /lus/theta-fs0/software/thetagpu/
git clone https://github.com/hypre-space/hypre.git hypre-cpu
cd hypre-cpu/src

# git checkout v2.22.0
make clean

# https://github.com/hypre-space/hypre
./configure --enable-shared
# --with-openmp

# ./configure  --with-blas-lib="blas-lib-name" \
#              --with-blas-lib-dirs="path-to-blas-lib" \
#              --with-lapack-lib="lapack-lib-name" \
#              --with-lapack-lib-dirs="path-to-lapack-lib"

make -j128

# https://hypre.readthedocs.io/en/latest/ch-misc.html#linking-to-the-library
