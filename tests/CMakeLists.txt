project(tests)

find_package(GTest REQUIRED)

add_executable(tests main.cpp)
target_link_libraries(tests ${GTEST_LIBRARIES})