help([[
Parallel HDF5 library version 1.8.22, built with CUDA-aware OpenMPI
]])

whatis("Name: HDF5")
whatis("Version: 1.8.22")
whatis("Category: hdf5")
whatis("Keywords: hdf5")
whatis("Description: Parallel HDF5 library")
whatis("URL: https://www.hdfgroup.org/solutions/hdf5/")

-- module use /lus/theta-fs0/software/environment/thetagpu/lmod/tmp
prepend_path("MODULEPATH","/lus/theta-fs0/software/environment/thetagpu/lmod/tmp")
depends_on("openmpi/openmpi-4.1.0_ucx-1.11.0_gcc-9.3.0")

local hdf5_root = "/lus/theta-fs0/software/thetagpu/hdf5/1.8.22/"
setenv("HDF5_ROOT",hdf5_root)
setenv("HDF5_DIR",hdf5_root)
-- HDF5 "make check-p" testph5diff.sh will not pass unless the warnings are suppressed
setenv("UCX_LOG_LEVEL","error")

prepend_path("PATH",pathJoin(hdf5_root,"bin/"))
prepend_path("CPATH",pathJoin(hdf5_root,"include/"))
prepend_path("LD_LIBRARY_PATH",pathJoin(hdf5_root,"lib/"))

family("hdf5")
