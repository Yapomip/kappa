
find_package(yaml-cpp QUIET PATHS ${yaml-cpp_DIR})
if(NOT yaml-cpp_FOUND)
    set(YAML_CPP_INSTALL ON CACHE BOOL "Enable installation of yaml-cpp targets" FORCE)

    include(FetchContent)
    FetchContent_Declare(
        yaml-cpp
        GIT_REPOSITORY https://github.com/jbeder/yaml-cpp.git
        GIT_TAG f0329d0efd2e62ceda5ee899c343ee445f6f7bd2
    )
    FetchContent_MakeAvailable(yaml-cpp)
endif()
