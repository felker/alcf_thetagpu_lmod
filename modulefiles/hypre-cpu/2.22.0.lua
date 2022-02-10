help([[
hypre-cpu 2.22.0+6631deb9
./configure --enable-shared
]])

-- whatis("Category: ")
whatis("Keywords: hypre LAPACK BLAS")
whatis("Description: HYPRE is a library of high performance preconditioners and solvers featuring multigrid methods for the solution of large, sparse linear systems of equations on massively parallel computers.")
whatis("URL: https://github.com/hypre-space/hypre")

depends_on("openmpi/openmpi-4.1.0_ucx-1.11.0_gcc-9.3.0")

prepend_path("LD_LIBRARY_PATH","/usr/local/cuda-11.3/lib64")
prepend_path("LD_LIBRARY_PATH","/lus/theta-fs0/software/thetagpu/hypre-cpu/src/hypre/lib")
setenv("HYPRE_ROOT","/lus/theta-fs0/software/thetagpu/hypre-cpu/")
