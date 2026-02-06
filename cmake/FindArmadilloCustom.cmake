
find_package(Armadillo QUIET)

if(NOT OpenBLAS_FOUND)
    find_package(Armadillo QUIET HINTS ${Armadillo_DIR})
endif()
