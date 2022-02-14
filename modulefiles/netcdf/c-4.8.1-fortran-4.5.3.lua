help([[
Parallel NetCDF
C library version 4.8.1
Fortran library version 4.5.3
Built with OpenMPI 4.0.5 (openmpi/openmpi-4.0.5_ucx-1.10.0_nvhpc-21.7)
and P-HDF5 1.8.22 with NVHPC compilers 21.7
]])

-- whatis("Category: ")
whatis("Keywords: NetCDF")
whatis("Description: NetCDF (Network Common Data Form) is a set of software libraries and machine-independent data formats that support the creation, access, and sharing of array-oriented scientific data.")
whatis("URL: https://www.unidata.ucar.edu/software/netcdf/")

depends_on("openmpi/openmpi-4.0.5_ucx-1.10.0_nvhpc-21.7")
depends_on("hdf5/1.8.22-nvhpc")
depends_on("nvhpc-nompi/21.7") 
local netcdf_root = "/lus/theta-fs0/software/thetagpu/netcdf-nvhpc/"

prepend_path("LD_LIBRARY_PATH","/usr/local/cuda-11.4/lib64")
prepend_path("PATH",pathJoin(netcdf_root,"bin/"))
prepend_path("CPATH",pathJoin(netcdf_root,"include/"))
prepend_path("LD_LIBRARY_PATH",pathJoin(netcdf_root,"lib/"))
setenv("NETCDF_DIR",netcdf_root)

family("netcdf")