
find_package(OpenBLAS QUIET PATHS ${OpenBLAS_DIR})

# kappa\dependencies\OpenBLAS\lib\cmake\openblas\OpenBLASConfig.cmake
if(OpenBLAS_FOUND AND NOT TARGET OpenBLAS AND NOT TARGET OpenBLAS::OpenBLAS) 
    get_filename_component(OpenBLAS_ROOT_DIR ${OpenBLAS_INCLUDE_DIRS} DIRECTORY)
    unset(OpenBLAS_INCLUDE_DIRS)
    unset(OpenBLAS_LIBRARIES)

    add_library(OpenBLAS SHARED IMPORTED)
    add_library(OpenBLAS::OpenBLAS ALIAS OpenBLAS)

    set_target_properties(OpenBLAS PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${OpenBLAS_ROOT_DIR}/include"
        IMPORTED_IMPLIB "${OpenBLAS_ROOT_DIR}/lib/libopenblas.lib"
        IMPORTED_LOCATION "${OpenBLAS_ROOT_DIR}/bin/libopenblas.dll"
    )

    message(STATUS "OpenBLAS_ROOT_DIR ${OpenBLAS_ROOT_DIR}")
    set(OpenBLASCustom_FOUND ON)
endif()
