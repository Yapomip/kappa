
find_package(Armadillo QUIET)

if(NOT Armadillo_FOUND)
    find_package(Armadillo QUIET HINTS ${Armadillo_DIR})
endif()

if(Armadillo_FOUND)
    set(ArmadilloCustom_FOUND ON)
endif()