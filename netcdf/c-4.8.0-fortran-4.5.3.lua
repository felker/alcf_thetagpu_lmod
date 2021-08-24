help([[
Parallel NetCDF
C library version 4.8.0+07b14642
Fortran library version 4.5.3
Built with OpenMPI 4.1.0 (openmpi/openmpi-4.1.0_ucx-1.11.0_gcc-9.3.0)
and P-HDF5 1.8.22
]])

-- whatis("Category: ")
whatis("Keywords: NetCDF")
whatis("Description: NetCDF (Network Common Data Form) is a set of software libraries and machine-independent data formats that support the creation, access, and sharing of array-oriented scientific data.")
whatis("URL: https://www.unidata.ucar.edu/software/netcdf/")

-- depends_on("openmpi/openmpi-4.1.0_ucx-1.11.0_gcc-9.3.0")
depends_on("hdf5/1.8.22")

local netcdf_root = "/lus/theta-fs0/software/thetagpu/netcdf/"

prepend_path("LD_LIBRARY_PATH","/usr/local/cuda-11.3/lib64")
prepend_path("PATH",pathJoin(netcdf_root,"bin/"))
prepend_path("CPATH",pathJoin(netcdf_root,"include/"))
prepend_path("LD_LIBRARY_PATH",pathJoin(netcdf_root,"lib/"))
-- setenv("HYPRE_ROOT","/lus/theta-fs0/software/thetagpu/hypre/")

family("netcdf")