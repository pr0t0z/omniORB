################################################################################
# Copyright (c) 2013-2014, Julien Bigot - CEA (julien.bigot@cea.fr)
# All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
################################################################################

#
# Find the omniORB libraries and include dir
#
# The following variables are set:
# OmniORB4_FOUND        - When false, don't try to use omniORB
# OmniORB4_INCLUDE_DIR  - OmniORB include directory
# OmniORB4_INCLUDE_DIRS - All directories to include to use omniORB (including dependancies such as omnithread)
# OmniORB4_LIBRARY      - The OmniORB library
# OmniORB4_LIBRARIES    - All libraries to link against to use omniORB (including dependancies such as omnithread)
# OmniORB4_VERSION      - A string of the form X.Y.Z representing the version
# OmniORB4_OMNIIDL      - The idl compiler command (when found)
# OmniORB4_OMNINAMES    - the omniNames ORB server command (when found)

#### Find paths
#
# OMNI_DIR can be used to make it simpler to find the various include
# directories and compiled libraries when omniORB was not installed in the
# usual/well-known directories (e.g. because you made an in tree-source
# compilation or because you installed it in an "unusual" directory).
# Just set OMNI_DIR to point to your specific installation directory.
#
# the OMNI_DIR environment variable (as opposed to the OMNI_DIR cmake variable)
# is also used to search for an omniORB installation.
#
# WARNING: The order of precedence is the following
#    1/ when set OMNI_DIR (the cmake variable)
#    2/ when set OMNI_DIR (the environment variable)
#    3/ the default system path
# This precedence order goes against the usual pratice and default behavior
# of cmake's FIND_* macros. For more on this debate see e.g.
#     http://www.mail-archive.com/kde-buildsystem@kde.org/msg00589.html

#### some libs installed by omniorb
# omnithread3   - dependancy:       portable thread support
# omniORB4      - checked for here: base CORBA support
# omniDynamic4  - depends on us:    dynamic features
# COS4          - depends on us:    stubs and skeletons for the COS service interfaces
# COSDynamic4   - depends on us:    dynamic stubs for the COS service interfaces
# omniCodeSets4 - depends on us:    extra code sets for string transformation
# omnisslTP     - depends on us:    SSL transport (built if OpenSSL is available

#=============================================================================
# Copyright (c) 2013-2014, Julien Bigot - CEA (julien.bigot@cea.fr)
# All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#=============================================================================

cmake_minimum_required(VERSION 2.8)

find_package(PkgConfig)

include(FindPackageHandleStandardArgs)

set(OMNI_DIR "$ENV{OMNI_DIR}" CACHE PATH "OmniORB install directory")

# dependancy on omnithread3
unset(_FIND_PACKAGE_ARGS)
if ( DEFINED PACKAGE_FIND_VERSION )
	list(APPEND _FIND_PACKAGE_ARGS "${PACKAGE_FIND_VERSION}")
endif()
if ( OmniORB4_FIND_QUIETLY )
	list(APPEND _FIND_PACKAGE_ARGS QUIET)
endif()
if ( OmniORB4_FIND_REQUIRED )
	list(APPEND _FIND_PACKAGE_ARGS REQUIRED)
endif()
find_package(omnithread3 ${_FIND_PACKAGE_ARGS})
unset(_FIND_PACKAGE_ARGS)

# Use pkg-config to get hints about paths
if ( PKG_CONFIG_FOUND )
	set(_PKGCONFIG_MODULE "omniORB4")
	if ( DEFINED PACKAGE_FIND_VERSION )
		set(_PKGCONFIG_MODULE "${_PKGCONFIG_MODULE}>=${PACKAGE_FIND_VERSION}")
	endif()
	pkg_check_modules(OMNIORB4_PKGCONF QUIET "${_PKGCONFIG_MODULE}")
	unset(_PKGCONFIG_ARGS)
endif()

# Include dir
find_path(OmniORB4_INCLUDE_DIR
	NAMES omniORB4/CORBA.h
	PATHS "${OMNI_DIR}" "$ENV{OMNI_DIR}" "${OMNI_DIR}/include" "$ENV{OMNI_DIR}/include" NO_DEFAULT_PATH
	DOC "the omniORB include directory"
)
find_path(OmniORB4_INCLUDE_DIR
	NAMES omniORB4/CORBA.h
	HINTS "${OMNIORB4_PKGCONF_INCLUDE_DIRS}"
	DOC "the omniORB include directory"
)
list(APPEND OmniORB4_INCLUDE_DIRS "${OmniORB4_INCLUDE_DIR}"  ${omnithread3_INCLUDE_DIRS})

# Library
find_library(OmniORB4_LIBRARY
	NAMES omniORB4
	PATHS "${OMNI_DIR}" "$ENV{OMNI_DIR}" "${OMNI_DIR}/lib" "$ENV{OMNI_DIR}/lib" NO_DEFAULT_PATH
	DOC "the omniORB library"
)
find_library(OmniORB4_LIBRARY
	NAMES omniORB4
	HINTS "${OMNITHREAD3_PKGCONF_LIBRARY_DIRS}"
	DOC "the omniORB library"
)
list(APPEND OmniORB4_LIBRARIES "${OmniORB4_LIBRARY}"  ${omnithread3_LIBRARIES})

# Omniidl
find_program(OmniORB4_OMNIIDL
	NAMES omniidl
	PATHS "${OMNI_DIR}" "$ENV{OMNI_DIR}" "${OMNI_DIR}/bin" "$ENV{OMNI_DIR}/bin" NO_DEFAULT_PATH
	DOC "path to omniidl (OmniORB IDL compiler)"
)
find_program(OmniORB4_OMNIIDL
	NAMES omniidl
	HINTS "${OMNITHREAD3_PKGCONF_LIBRARY_DIRS}/../bin" "${OMNIORB4_PKGCONF_INCLUDE_DIRS}/../bin"
	DOC "path to omniidl (OmniORB IDL compiler)"
)

# Omninames
find_program(OmniORB4_OMNINAMES
	NAMES omniNames
	PATHS "${OMNI_DIR}" "$ENV{OMNI_DIR}" "${OMNI_DIR}/bin" "$ENV{OMNI_DIR}/bin" NO_DEFAULT_PATH
	DOC "path to omniNames (OmniORB name server)"
)
find_program(OmniORB4_OMNINAMES
	NAMES omniNames
	HINTS "${OMNITHREAD3_PKGCONF_LIBRARY_DIRS}/../bin" "${OMNIORB4_PKGCONF_INCLUDE_DIRS}/../bin"
	DOC "path to omniNames (OmniORB name server)"
)

if ( EXISTS ${OmniORB4_INCLUDE_DIR}/omniORB4/acconfig.h )
	file(STRINGS ${OmniORB4_INCLUDE_DIR}/omniORB4/acconfig.h OMNIORB_ACCONFIG_H)
	string(REGEX MATCH "#define[\t ]+PACKAGE_VERSION[\t ]+\"([0-9]+.[0-9]+.[0-9]+)\"" OMNIORB_ACCONFIG_H "${OMNIORB_ACCONFIG_H}")
	string(REGEX REPLACE ".*\"([0-9]+.[0-9]+.[0-9]+)\".*" "\\1" OmniORB4_VERSION "${OMNIORB_ACCONFIG_H}")
endif()

mark_as_advanced(CLEAR OMNI_DIR)
 
find_package_handle_standard_args(OmniORB4 REQUIRED_VARS OmniORB4_INCLUDE_DIR OmniORB4_LIBRARY VERSION_VAR OmniORB4_VERSION)
set(OmniORB4_FOUND ${OMNIORB4_FOUND})

if ( ${OMNIORB4_FOUND} )
	mark_as_advanced(FORCE OMNI_DIR OmniORB4_INCLUDE_DIR OmniORB4_LIBRARY)
endif()
if ( ${OmniORB4_OMNIIDL} )
	mark_as_advanced(OmniORB4_OMNIIDL)
endif()
if ( ${OmniORB4_OMNINAMES} )
	mark_as_advanced(OmniORB4_OMNINAMES)
endif()
