help([[
hypre 2.22.0+6631deb9
./configure --with-cuda --with-gpu-arch='80' --with-cuda-home=/usr/local/cuda-11.3 --enable-gpu-profiling --enable-cusparse --enable-cublas --enable-curand --enable-device-memory-pool --enable-unified-memory --enable-shared  --enable-gpu-aware-mpi  
]])

-- whatis("Category: ")
whatis("Keywords: hypre LAPACK BLAS")
whatis("Description: HYPRE is a library of high performance preconditioners and solvers featuring multigrid methods for the solution of large, sparse linear systems of equations on massively parallel computers.")
whatis("URL: https://github.com/hypre-space/hypre")

depends_on("openmpi/openmpi-4.0.5")

prepend_path("LD_LIBRARY_PATH","/usr/local/cuda-11.3/lib64")
prepend_path("LD_LIBRARY_PATH","/lus/theta-fs0/software/thetagpu/hypre/src/hypre/lib")
-- setenv("HYPRE_DIR","/lus/theta-fs0/software/thetagpu/hypre/src/hypre")
setenv("HYPRE_ROOT","/lus/theta-fs0/software/thetagpu/hypre/")
