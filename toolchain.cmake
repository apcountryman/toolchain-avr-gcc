# toolchain-avr-gcc
#
# Copyright 2019-2024, Andrew Countryman <apcountryman@gmail.com> and the
# toolchain-avr-gcc contributors
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
# file except in compliance with the License. You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under
# the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied. See the License for the specific language governing
# permissions and limitations under the License.

# File: toolchain.cmake
# Description: avr-gcc CMake toolchain.

cmake_minimum_required( VERSION 3.13.4 )

mark_as_advanced(
    CMAKE_TOOLCHAIN_FILE
    CMAKE_INSTALL_PREFIX
    )

set( CMAKE_SYSTEM_NAME      "Generic"   )
set( CMAKE_SYSTEM_PROCESSOR "Microchip-AVR" )

find_program( CMAKE_C_COMPILER avr-gcc )
mark_as_advanced( CMAKE_C_COMPILER )
if( "${CMAKE_C_COMPILER}" STREQUAL "CMAKE_C_COMPILER-NOTFOUND" )
    message( FATAL_ERROR "avr-gcc not found" )
endif( "${CMAKE_C_COMPILER}" STREQUAL "CMAKE_C_COMPILER-NOTFOUND" )

find_program( CMAKE_CXX_COMPILER avr-g++ )
mark_as_advanced( CMAKE_CXX_COMPILER )
if( "${CMAKE_CXX_COMPILER}" STREQUAL "CMAKE_CXX_COMPILER-NOTFOUND" )
    message( FATAL_ERROR "avr-g++ not found" )
endif( "${CMAKE_CXX_COMPILER}" STREQUAL "CMAKE_CXX_COMPILER-NOTFOUND" )

find_program( CMAKE_LINKER avr-ld )
mark_as_advanced( CMAKE_LINKER )
if( "${CMAKE_LINKER}" STREQUAL "CMAKE_LINKER-NOTFOUND" )
    message( FATAL_ERROR "avr-ld not found" )
endif( "${CMAKE_LINKER}" STREQUAL "CMAKE_LINKER-NOTFOUND" )

find_program( CMAKE_NM avr-nm )
mark_as_advanced( CMAKE_NM )
if( "${CMAKE_NM}" STREQUAL "CMAKE_NM-NOTFOUND" )
    message( FATAL_ERROR "avr-nm not found" )
endif( "${CMAKE_NM}" STREQUAL "CMAKE_NM-NOTFOUND" )

find_program( CMAKE_OBJCOPY avr-objcopy )
mark_as_advanced( CMAKE_OBJCOPY )
if( "${CMAKE_OBJCOPY}" STREQUAL "CMAKE_OBJCOPY-NOTFOUND" )
    message( FATAL_ERROR "avr-objcopy not found" )
endif( "${CMAKE_OBJCOPY}" STREQUAL "CMAKE_OBJCOPY-NOTFOUND" )

find_program( CMAKE_OBJDUMP avr-objdump )
mark_as_advanced( CMAKE_OBJDUMP )
if( "${CMAKE_OBJDUMP}" STREQUAL "CMAKE_OBJDUMP-NOTFOUND" )
    message( FATAL_ERROR "avr-objdump not found" )
endif( "${CMAKE_OBJDUMP}" STREQUAL "CMAKE_OBJDUMP-NOTFOUND" )

find_program( CMAKE_AR avr-ar )
mark_as_advanced( CMAKE_AR )
if( "${CMAKE_AR}" STREQUAL "CMAKE_AR-NOTFOUND" )
    message( FATAL_ERROR "avr-ar not found" )
endif( "${CMAKE_AR}" STREQUAL "CMAKE_AR-NOTFOUND" )

find_program( CMAKE_RANLIB avr-ranlib )
mark_as_advanced( CMAKE_RANLIB )
if( "${CMAKE_RANLIB}" STREQUAL "CMAKE_RANLIB-NOTFOUND" )
    message( FATAL_ERROR "avr-ranlib not found" )
endif( "${CMAKE_RANLIB}" STREQUAL "CMAKE_RANLIB-NOTFOUND" )

find_program( CMAKE_STRIP avr-strip )
mark_as_advanced( CMAKE_STRIP )
if( "${CMAKE_STRIP}" STREQUAL "CMAKE_STRIP-NOTFOUND" )
    message( FATAL_ERROR "avr-strip not found" )
endif( "${CMAKE_STRIP}" STREQUAL "CMAKE_STRIP-NOTFOUND" )
