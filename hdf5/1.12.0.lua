help([[
Parallel HDF5 library version 1.12.0, built with CUDA-aware OpenMPI
]])

depends_on("openmpi/openmpi-4.0.5")

whatis("Name: HDF5")
whatis("Version: 1.12.0")
whatis("Category: hdf5")
whatis("Keywords: hdf5")
whatis("Description: Parallel HDF5 library")
whatis("URL: https://www.hdfgroup.org/solutions/hdf5/")

local hdf5_root = "/lus/theta-fs0/software/thetagpu/hdf5/1.12.0/"
setenv("HDF5_ROOT",hdf5_root)
setenv("HDF5_DIR",hdf5_root)

prepend-path("PATH",pathJoin(hdf5_root,"bin/")
prepend-path("CPATH",pathJoin(hdf5_root,"include/")
prepend-path("LD_LIBRARY_PATH",pathJoin(hdf5_root,"lib/")

family("hdf5")
