cmake_minimum_required(VERSION 2.6.3)
project(eg3_client)
add_definitions(-std=c++11)

include(../config.cmake)

file(GLOB SRC . *.h *.cpp)

add_executable( eg3_client ${IDL_FILES} ${SRC} )

target_link_libraries( eg3_client ${OmniORB4_LIBRARIES} )
