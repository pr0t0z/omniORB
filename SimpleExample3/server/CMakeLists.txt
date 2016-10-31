cmake_minimum_required(VERSION 2.6.3)
project(eg3_server)
add_definitions(-std=c++11)

include(../config.cmake)

file(GLOB SRC . *.h *.cpp)

add_executable( eg3_server ${IDL_FILES} ${SRC} )

target_link_libraries(eg3_server ${OmniORB4_LIBRARIES})
