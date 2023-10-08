cmake_minimum_required(VERSION 3.12)

project(MsgBox)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_subdirectory(deploymentManager)
add_subdirectory(tests)
include(ExternalProject)

# Set the directory where Google Test will be downloaded and built
set(GTEST_LOCATION "${CMAKE_SOURCE_DIR}/libs/gtest")

# ExternalProject setup for Google Test
ExternalProject_Add(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG release-1.11.0  # Adjust the tag/version as needed
    PREFIX "${GTEST_LOCATION}"
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX="${SOURCE_DIR}/libs/googletest"
)

# Specify where to find the Google Test headers and libraries
ExternalProject_Get_Property(googletest SOURCE_DIR BINARY_DIR)
target_include_directories(tests PRIVATE "${GTEST_LOCATION}/src/googletest/googletest/include")
target_link_directories(tests PRIVATE "${GTEST_LOCATION}/src/googletest/googletest")

# Add a dependency so that Google Test is built before your tests
add_dependencies(tests googletest)

add_custom_target(msgbox
    COMMAND ${CMAKE_CXX_COMPILER} ${CMAKE_SOURCE_DIR}/deploymentManager/main.cpp -o msgbox
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    DEPENDS deploymentManager
)

add_custom_target(msgbox_UT
    COMMAND ${CMAKE_CXX_COMPILER}
            ${CMAKE_SOURCE_DIR}/tests/main.cpp -o msgbox_UT
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    DEPENDS tests ${GTEST_LIBRARIES}
)