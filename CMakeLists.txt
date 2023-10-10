cmake_minimum_required(VERSION 3.12)

project(MsgBox)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_subdirectory(deploymentManager)
add_subdirectory(tests)
include(ExternalProject)

# ---------------------------- GTEST ---------------------------------------------

set(GTEST_LOCATION "${CMAKE_SOURCE_DIR}/libs/gtest")

ExternalProject_Add(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG release-1.11.0
    PREFIX "${GTEST_LOCATION}"
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX="${SOURCE_DIR}/libs/googletest"
)

ExternalProject_Get_Property(googletest SOURCE_DIR BINARY_DIR)
target_include_directories(tests PRIVATE "${GTEST_LOCATION}/src/googletest/googletest/include")
target_link_directories(tests PRIVATE "${GTEST_LOCATION}/src/googletest/googletest")

add_dependencies(tests googletest)

# ---------------------------- GTEST END -----------------------------------------
# ---------------------------- SPDLOG --------------------------------------------

set(SPDLOG_LOCATION "${CMAKE_SOURCE_DIR}/libs/spdlog")

ExternalProject_Add(
    spdlog
    GIT_REPOSITORY https://github.com/gabime/spdlog.git
    GIT_TAG v1.12.0
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX="${SPDLOG_LOCATION}g"
)

ExternalProject_Get_Property(spdlog SOURCE_DIR BINARY_DIR)
target_include_directories(deploymentManager PRIVATE "${SPDLOG_LOCATION}/src/spdlog/include")
target_link_directories(deploymentManager PRIVATE "${SPDLOG_LOCATION}/src/spdlog/include")

add_dependencies(deploymentManager spdlog)

# ---------------------------- SPDLOG END ----------------------------------------

add_custom_target(msgbox
    COMMAND ${CMAKE_CXX_COMPILER}
            ${CMAKE_SOURCE_DIR}/deploymentManager/main.cpp -o msgbox
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    DEPENDS deploymentManager ${SPDLOG_LIBRARIES}
)

add_custom_target(msgbox_UT
    COMMAND ${CMAKE_CXX_COMPILER}
            ${CMAKE_SOURCE_DIR}/tests/main.cpp -o msgbox_UT
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    DEPENDS tests ${GTEST_LIBRARIES}
)