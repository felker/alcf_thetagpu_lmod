help([[
Parallel NetCDF
C library version 4.8.0+07b14642
Fortran library version 4.5.3
Built with OpenMPI 4.1.1 (openmpi/openmpi-4.1.1_ucx-1.10.1_gcc-9.3.0.lua)
and P-HDF5 1.8.22
]])

-- whatis("Category: ")
whatis("Keywords: NetCDF")
whatis("Description: NetCDF (Network Common Data Form) is a set of software libraries and machine-independent data formats that support the creation, access, and sharing of array-oriented scientific data.")
whatis("URL: https://www.unidata.ucar.edu/software/netcdf/")

depends_on("openmpi/openmpi-4.1.1_ucx-1.10.1_gcc-9.3.0.lua")
depends_on("hdf5/1.8.22")

prepend_path("LD_LIBRARY_PATH","/usr/local/cuda-11.3/lib64")
prepend_path("LD_LIBRARY_PATH","/lus/theta-fs0/software/thetagpu/netcdf/lib")
-- setenv("HYPRE_ROOT","/lus/theta-fs0/software/thetagpu/hypre/")

family("netcdf")