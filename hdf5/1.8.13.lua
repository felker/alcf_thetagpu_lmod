help([[
Parallel HDF5 library version 1.8.13, built with CUDA-aware OpenMPI
]])

whatis("Name: HDF5")
whatis("Version: 1.8.13")
whatis("Category: hdf5")
whatis("Keywords: hdf5")
whatis("Description: Parallel HDF5 library")
whatis("URL: https://www.hdfgroup.org/solutions/hdf5/")

depends_on("openmpi/openmpi-4.0.5")

local hdf5_root = "/lus/theta-fs0/software/thetagpu/hdf5/1.8.13/"
setenv("HDF5_ROOT",hdf5_root)
setenv("HDF5_DIR",hdf5_root)

prepend_path("PATH",pathJoin(hdf5_root,"bin/"))
prepend_path("CPATH",pathJoin(hdf5_root,"include/"))
prepend_path("LD_LIBRARY_PATH",pathJoin(hdf5_root,"lib/"))

family("hdf5")
