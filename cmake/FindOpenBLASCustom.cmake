
find_package(OpenBLAS QUIET PATHS ${OpenBLAS_DIR})

# kappa\dependencies\OpenBLAS\lib\cmake\openblas\OpenBLASConfig.cmake
if(OpenBLAS_FOUND AND NOT TARGET OpenBLAS::OpenBLAS) 
    if(WIN32)
        get_filename_component(OpenBLAS_ROOT_DIR ${OpenBLAS_INCLUDE_DIRS} DIRECTORY)

        add_library(OpenBLAS::OpenBLAS SHARED IMPORTED)
        set_target_properties(OpenBLAS::OpenBLAS PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${OpenBLAS_ROOT_DIR}/include"
            IMPORTED_IMPLIB "${OpenBLAS_ROOT_DIR}/lib/libopenblas.lib"
            IMPORTED_LOCATION "${OpenBLAS_ROOT_DIR}/bin/libopenblas.dll"
        )
        message(STATUS "OpenBLAS_ROOT_DIR ${OpenBLAS_ROOT_DIR}")
        set(OpenBLAS_DIR ${OpenBLAS_ROOT_DIR})
    else()
        add_library(OpenBLAS::OpenBLAS UNKNOWN IMPORTED)
        set_target_properties(OpenBLAS::OpenBLAS PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${OpenBLAS_INCLUDE_DIRS}"
            IMPORTED_LOCATION "${OpenBLAS_LIBRARIES}"
        )
    endif()
    set(OpenBLASCustom_FOUND ON)
endif()
