cmake_minimum_required(VERSION 3.5 FATAL_ERROR)
# Add sources for a target
#  ADD_SOURCES(<target> <source1> [<source2> ...])
 function (add_sources target)
  # define the <target>_SRCS properties if necessary
  get_property(prop_defined GLOBAL PROPERTY ${target}_SRCS DEFINED)
  if(NOT prop_defined)
    define_property(GLOBAL PROPERTY ${target}_SRCS
      BRIEF_DOCS "Sources for the ${target} target"
      FULL_DOCS "List of source files for the ${target} target")
  endif()
  # create list of sources (absolute paths)
  set(SRCS)
  foreach(src IN LISTS ARGN)
    if(NOT IS_ABSOLUTE "${src}")
      get_filename_component(src "${src}" ABSOLUTE)
    endif()
    list(APPEND SRCS "${src}")
  endforeach()
  # append to global property
  set_property(GLOBAL APPEND PROPERTY "${target}_SRCS" "${SRCS}")
 endfunction()

file(GLOB_RECURSE LIB_SOURCES 
    RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
    "approximations/*.cpp"
    "interactions/*.cpp"
    "mixtures/*.cpp"
    "numerics/*.cpp"
    "particles/*.cpp"
)
message("${LIB_SOURCES}")
add_library(kappa++ SHARED ${LIB_SOURCES})

target_link_libraries(kappa++ yaml-cpp armadillo BLAS::BLAS LAPACK::LAPACK)

# target_link_libraries(kappa++ ${OPENBLAS_LIBRARY})
target_include_directories(kappa++ PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/approximations>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interactions>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/mixtures>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/numerics>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/particles>
    $<INSTALL_INTERFACE:include/kappa++>
)
message(${CMAKE_CURRENT_SOURCE_DIR})


install(TARGETS kappa++ EXPORT kappa++_targets 
    LIBRARY DESTINATION lib 
    INCLUDES DESTINATION include
)

install(EXPORT kappa++_targets
    FILE kappa++Config.cmake
    DESTINATION "cmake"
)

# Evaluate coverage
if(ENABLE_COVERAGE)
    add_coverage(kappa++)
endif()

