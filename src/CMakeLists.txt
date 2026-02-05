cmake_minimum_required(VERSION 3.5...3.25)

set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)

file(GLOB_RECURSE lib_sources 
    RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
    CONFIGURE_DEPENDS
    "approximations/*.cpp"
    "interactions/*.cpp"
    "mixtures/*.cpp"
    "numerics/*.cpp"
    "particles/*.cpp"
)

# message("${lib_sources}")

add_library(kappa++ SHARED ${lib_sources})
add_library(kappa++::kappa++ ALIAS kappa++)

target_link_libraries(kappa++ PRIVATE yaml-cpp::yaml-cpp)
# Need to armadillo becouse armadillo connect it by find path of library?! (it is very sadly)
target_link_libraries(kappa++ PUBLIC OpenBLAS::OpenBLAS)
target_link_libraries(kappa++ PUBLIC armadillo)

target_include_directories(kappa++ PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/approximations>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interactions>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/mixtures>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/numerics>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/particles>
    $<INSTALL_INTERFACE:include>
)
# message(${CMAKE_CURRENT_SOURCE_DIR})

foreach(dir approximations interactions mixtures numerics particles)
    file(GLOB headers RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} CONFIGURE_DEPENDS "${dir}/*.hpp" "${dir}/*.h")

    install(FILES ${headers}
        DESTINATION include
    )
endforeach()

install(
    TARGETS kappa++ 
    EXPORT kappa++Targets 
    LIBRARY DESTINATION lib 
    ARCHIVE DESTINATION lib 
    INCLUDES DESTINATION include
    RUNTIME DESTINATION lib
)

install(
    EXPORT kappa++Targets
    FILE kappa++Targets.cmake
    DESTINATION "cmake"
    NAMESPACE kappa++::
)

# Evaluate coverage
if(ENABLE_COVERAGE)
    add_coverage(kappa++)
endif()

