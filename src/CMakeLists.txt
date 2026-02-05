cmake_minimum_required(VERSION 3.5...3.25)
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

target_link_libraries(kappa++ PRIVATE yaml-cpp)
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
    install(DIRECTORY ${dir}
            DESTINATION include
            FILES_MATCHING 
            PATTERN "*.hpp" 
            PATTERN "*.h"
    )
endforeach()

install(
    TARGETS kappa++ 
    EXPORT kappa++Targets 
    LIBRARY DESTINATION lib 
    ARCHIVE DESTINATION lib 
    INCLUDES DESTINATION include
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

