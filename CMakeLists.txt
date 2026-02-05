###############################################################################
#
# High level cmake configuration file for the KAPPA project and associated
# helper tools and binaries. All of the various configuration options are
# defined here.
#
# author: L. Campoli (l.kampoli@spbu.ru) inspired by Mutation++
#
###############################################################################
#
# Copyright 2018 Saint Petersburg State University (SPBSU)
#
# This file is part of Kinetic Approach to Physical Processes in Atmospheres
# is an open-source library written in C++ (KAPPA) software package.
#
# KAPPA is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# KAPPA is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with KAPPA. If not, see <http://www.gnu.org/licenses/>.
#
cmake_minimum_required(VERSION 3.5...3.25)
cmake_policy(SET CMP0048 NEW)
# Enable IPO for CMake versions that support it
# cmake_policy(SET CMP0069 NEW)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

project(kappa++
    VERSION 1.0.0
    LANGUAGES CXX
)

# Add include path for cmake modules
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

################################################################################
# Build types
################################################################################

# Profile
set(CMAKE_CXX_FLAGS_PROFILE "-g3 -Wall -O3 -DNDEBUG" CACHE STRING
    "Flags used by the C++ compiler during Profile builds."
    FORCE )
set(CMAKE_C_FLAGS_PROFILE "-g3 -Wall -pedantic -O3 -DNDEBUG" CACHE STRING
    "Flags used by the C compiler during Profile builds."
    FORCE )
set(CMAKE_EXE_LINKER_FLAGS_PROFILE
    "" CACHE STRING
    "Flags used for linking binaries during Profile builds."
    FORCE )
set(CMAKE_SHARED_LINKER_FLAGS_PROFILE
    "" CACHE STRING
    "Flags used by the shared libraries linker during Profile builds."
    FORCE )
mark_as_advanced(
    CMAKE_CXX_FLAGS_PROFILE
    CMAKE_C_FLAGS_PROFILE
    CMAKE_EXE_LINKER_FLAGS_PROFILE
    CMAKE_SHARED_LINKER_FLAGS_PROFILE)

# Update the documentation string of CMAKE_BUILD_TYPE for GUIs and set the
# default build type as Release
if (NOT CMAKE_BUILD_TYPE)
    SET (CMAKE_BUILD_TYPE "Release" CACHE STRING
        "Choose the type of build, options are: None Debug Release
        RelWithDebInfo MinSizeRel Profile." FORCE)
endif ()

#set_property(TARGET tgt PROPERTY CXX_STANDARD 11)
#add_compile_options(-Wall -Wextra -pedantic -Werror -std=c++11)

################################################################################
# Install prefix settings
################################################################################

# set(CMAKE_INSTALL_PREFIX "../install" CACHE STRING
#    "Install path prefix, prepended onto install directories." FORCE)
mark_as_advanced(CMAKE_INSTALL_PREFIX)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++11 -lm")
if(KAPPA_PG)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pg")
endif()
if(CMAKE_COMPILER_IS_GNUCXX)
    set(CMAKE_CXX_FLAGS "-Wall -Wextra -Wno-unused-parameter -Wold-style-cast")
    set(CMAKE_CXX_FLAGS "-g")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++11 -lm -g -fopenmp ")
    # set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -I ${CMAKE_CURRENT_SOURCE_DIR}/kappa_deps/x86_64/include")
    # set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -I ${CMAKE_CURRENT_SOURCE_DIR}/kappa_deps/x86_64/include/yaml-cpp")
    # set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -I ${CMAKE_CURRENT_SOURCE_DIR}/kappa_deps/x86_64/include/armadillo_bits")
    # set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -I ${CMAKE_CURRENT_SOURCE_DIR}/kappa_deps/x86_64/include/boost")
    # set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -I ${CMAKE_CURRENT_SOURCE_DIR}/src/approximations")
    # set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -I ${CMAKE_CURRENT_SOURCE_DIR}/src/interactions")
    # set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -I ${CMAKE_CURRENT_SOURCE_DIR}/src/numerics")
    # set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -I ${CMAKE_CURRENT_SOURCE_DIR}/src/mixtures")
    # set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -I ${CMAKE_CURRENT_SOURCE_DIR}/src/particles")
endif ()

################################################################################
# Doxygen documentation generation
################################################################################
option (BUILD_DOCUMENTATION
    "Use Doxygen to create the HTML based API documentation" OFF)

if (BUILD_DOCUMENTATION)
    FIND_PACKAGE(Doxygen)

    if (NOT DOXYGEN_FOUND)
        message(FATAL_ERROR
            "Doxygen is needed to build the documentation. Please install it
                correctly")
    endif()
    # Configure the Template Doxyfile for our specific project
    configure_file(Doxyfile.in
                        ${PROJECT_BINARY_DIR}/Doxyfile  @ONLY IMMEDIATE)
    # Add a custom target to run Doxygen when ever the project is built
    add_custom_target (docs
        COMMAND ${DOXYGEN_EXECUTABLE} ${PROJECT_BINARY_DIR}/Doxyfile
        SOURCES ${PROJECT_BINARY_DIR}/Doxyfile)
endif()

#################################################################################
# Find the required packages: OpenBLAS(Blas, Lapack), Armadillo, Yaml-cpp, Boost
#################################################################################

if (NOT yaml-cpp_DIR)
    set(yaml-cpp_DIR "${CMAKE_CURRENT_SOURCE_DIR}/dependencies/yaml")
endif()
# find_package(YamlCustom REQUIRED)
find_package(yaml-cpp QUIET PATHS ${yaml-cpp_DIR})
message(STATUS "YAML_CPP_DIR ${yaml-cpp_DIR}")


# Where OpenBLASConfid.cmake is
if (NOT OpenBLAS_DIR)
    set(OpenBLAS_DIR "${CMAKE_CURRENT_SOURCE_DIR}/dependencies/OpenBLAS")
endif()
find_package(OpenBLASCustom REQUIRED)
message(STATUS "OpenBLAS_DIR ${OpenBLAS_DIR}")

# Where ArmadilloConfid.cmake is
if (NOT Armadillo_DIR)
    set(Armadillo_DIR "${CMAKE_CURRENT_SOURCE_DIR}/dependencies/arma")
endif()
find_package(Armadillo REQUIRED HINTS ${Armadillo_DIR})
message(STATUS "Armadillo_DIR ${Armadillo_DIR}")

################################################################################
# Source code
################################################################################

option(ENABLE_COVERAGE "Generate coverage for codecov.io" OFF)
list(APPEND LCOV_REMOVE_PATTERNS
    "'*/tests/*'"
)
include(CodeCoverage)

add_subdirectory(src)

################################################################################
# Install the data directory in the install folder
################################################################################

set(RESOURCES_INSTALL_DIR "data")
set(RESOURCES_FILES_DIR "data")
set(RESOURCES_FILES "${RESOURCES_FILES_DIR}/interaction.yaml" "${RESOURCES_FILES_DIR}/particles.yaml")
install(FILES ${RESOURCES_FILES} DESTINATION ${RESOURCES_INSTALL_DIR})

set(KAPPA_RESOURCES_FILES_DIR "${CMAKE_CURRENT_SOURCE_DIR}/${RESOURCES_FILES_DIR}" CACHE INTERNAL "where is kappa/data")
message(STATUS "Path to resources ${KAPPA_RESOURCES_FILES_DIR}")

include(CMakePackageConfigHelpers)
configure_package_config_file(
    "Config.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/kappa++Config.cmake"
    INSTALL_DESTINATION "cmake"
)
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/kappa++Config.cmake" DESTINATION "cmake")
# On Windows need to copy libopenblas.dll to exe who use kappa++
if (WIN32)
    set(OpenBLAS_DIR ${OpenBLAS_ROOT_DIR})
    message(STATUS "OpenBLAS_DIR ${OpenBLAS_DIR}")
    install(FILES "cmake/FindOpenBLASCustom.cmake" DESTINATION "cmake")
endif()

################################################################################
# CTest
################################################################################
option (ENABLE_TESTING "Enable regression testing with CTest" OFF)

if (ENABLE_TESTING OR ENABLE_COVERAGE)
    find_package(Catch2)
    enable_testing()
    add_subdirectory(tests)
    add_subdirectory(examples)
endif()
