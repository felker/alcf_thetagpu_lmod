#!/bin/bash

cd /lus/theta-fs0/software/thetagpu/
git clone https://github.com/hypre-space/hypre.git hypre-gpu
cd hypre-gpu/src

# git checkout v2.22.0
make clean

# https://github.com/hypre-space/hypre
./configure --with-cuda --with-gpu-arch='80' --with-cuda-home=/usr/local/cuda-11.3 --enable-gpu-profiling --enable-cusparse --enable-cublas --enable-curand --enable-device-memory-pool --enable-unified-memory --enable-shared --enable-gpu-aware-mpi

make -j128

# https://hypre.readthedocs.io/en/latest/ch-misc.html#linking-to-the-library
