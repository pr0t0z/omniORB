#General configuration file for client and server projects
set(PREFIX ${CMAKE_CURRENT_LIST_DIR})
#Add config files to cmake
set(CMAKE_MODULE_PATH ${PREFIX}/config)

#Set directory variables
set(Client_DIR ${PREFIX}/client)
set(Server_DIR ${PREFIX}/server)
set(IDL_DIR ${PREFIX}/idl)

#find OmniORB
find_package(OmniORB4)
find_package(GenerateIDL)
#Use idl.cmake file GENERATE_IDL_CPP macro to generate the stubs from the idl file
GENERATE_IDL_CPP(echo ${IDL_DIR})
#Create variable that points to the idl stubs generated
file(GLOB IDL_FILES ${IDL_DIR}/*.hh ${IDL_DIR}/*.cc) 

include_directories(${IDL_DIR})
