# toolchain-avr-gcc
#
# Copyright 2019-2021, Andrew Countryman <apcountryman@gmail.com> and the
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

find_program( CMAKE_AVRDUDE avrdude )
mark_as_advanced( CMAKE_AVRDUDE )

# Add avrdude programming targets for an executable.
#
# SYNOPSIS
#     add_avrdude_programming_targets(
#         <executable>
#         [CONFIGURATION_FILE <configuration_file>]
#         [PORT <port>]
#         [VERBOSITY VERY_QUIET|QUIET|VERBOSE|VERY_VERBOSE]
#         [PROGRAM_EEPROM <avrdude_argument>...]
#         [PROGRAM_FLASH <avrdude_argument>...]
#         [VERIFY_EEPROM <avrdude_argument>...]
#         [VERIFY_FLASH <avrdude_argument>...]
#     )
# OPTIONS
#     <executable>
#         Specify the name of the executable that programming targets will be created for.
#     CONFIGURATION_FILE <configuration_file>
#         Specify the location of the avrdude configuration file. Equivalent to avrdude's
#         "-C <configuration_file>" option. Passed to all created avrdude targets.
#     PORT <port>
#         Specify the port the AVR is connected to. Equivalent to avrdude's "-P <port>"
#         option. Passed to all created avrdude targets.
#     PROGRAM_EEPROM <avrdude_argument>...
#         Create an EEPROM programming target ("<executable>-program-eeprom") that uses
#         the specified avrdude arguments. An EEPROM programming/verification hex file
#         ("<executable>.eeprom.hex") creation target ("<executable>-hex-eeprom") will be
#         created as well. The EEPROM programming/verification hex file creation target
#         will be added to ALL.
#     PROGRAM_FLASH  <avrdude_argument>...
#         Create a Flash programming target ("<executable>-program-flash") that uses the
#         specified avrdude arguments. A Flash programming/verification hex file
#         ("<executable>.flash.hex") creation target ("<executable>-hex-flash") will be
#         created as well. The Flash programming/verification hex file creation target
#         will be added to ALL.
#     VERBOSITY VERY_QUIET|QUIET|VERBOSE|VERY_VERBOSE
#         Specify avrdude's output verbosity. "VERY_QUIET" is equivalent to avrdude's "-q
#         -q" option. "QUIET" is equivalent to avrdude's "-q" option. "VERBOSE" is
#         equivalent to avrdude's "-v" option. "VERY_VERBOSE" is equivalent to avrdude's
#         "-v -v" option. Passed to all created avrdude targets.
#     VERIFY_EEPROM <avrdude_argument>...
#         Create an EEPROM verification target ("<executable>-verify-eeprom") that uses
#         the specified avrdude arguments. An EEPROM programming/verification hex file
#         ("<executable>.eeprom.hex") creation target ("<executable>-hex-eeprom") will be
#         created as well. The EEPROM programming/verification hex file creation target
#         will be added to ALL.
#     VERIFY_FLASH  <avrdude_argument>...
#         Create a Flash verification target ("<executable>-verify-flash") that uses the
#         specified avrdude arguments. A Flash programming/verification hex file
#         ("<executable>.flash.hex") creation target ("<executable>-hex-flash") will be
#         created as well. The Flash programming/verification hex file creation target
#         will be added to ALL.
# EXAMPLES
#     add_avrdude_programming_targets(
#         example
#         PORT          /dev/ttyACM0
#         VERBOSITY     VERY_VERBOSE
#         PROGRAM_FLASH -p atmega2560 -c wiring -b 115200 -D
#         VERIFY_FLASH  -p atmega2560 -c wiring -b 115200
#     )
#     add_avrdude_programming_targets(
#         example
#         PORT          /dev/ttyACM0
#         VERBOSITY     VERY_VERBOSE
#         PROGRAM_FLASH -p atmega328p -c arduino -b 115200 -D
#         VERIFY_FLASH  -p atmega328p -c arduino -b 115200
#     )
function( add_avrdude_programming_targets executable )
    if( "${CMAKE_AVRDUDE}" STREQUAL "CMAKE_AVRDUDE-NOTFOUND" )
        message( FATAL_ERROR "avrdude not found" )
    endif( "${CMAKE_AVRDUDE}" STREQUAL "CMAKE_AVRDUDE-NOTFOUND" )

    cmake_parse_arguments(
        add_avrdude_programming_targets
        ""
        "CONFIGURATION_FILE;PORT;VERBOSITY"
        "PROGRAM_EEPROM;PROGRAM_FLASH;VERIFY_EEPROM;VERIFY_FLASH"
        ${ARGN}
    )

    if( DEFINED add_avrdude_programming_targets_UNPARSED_ARGUMENTS )
        message(
            FATAL_ERROR
            "'${add_avrdude_programming_targets_UNPARSED_ARGUMENTS}' are not supported arguments"
        )
    endif( DEFINED add_avrdude_programming_targets_UNPARSED_ARGUMENTS )

    if( DEFINED add_avrdude_programming_targets_PROGRAM_FLASH OR DEFINED add_avrdude_programming_targets_VERIFY_FLASH )
        add_custom_command(
            OUTPUT  "${executable}.flash.hex"
            COMMAND "${CMAKE_OBJCOPY}" -O ihex -R .eeprom "${executable}" "${executable}.flash.hex"
            DEPENDS "${executable}"
        )
        add_custom_target(
            "${executable}-hex-flash" ALL
            DEPENDS "${executable}.flash.hex"
        )
    endif( DEFINED add_avrdude_programming_targets_PROGRAM_FLASH OR DEFINED add_avrdude_programming_targets_VERIFY_FLASH )

    if( DEFINED add_avrdude_programming_targets_PROGRAM_EEPROM OR DEFINED add_avrdude_programming_targets_VERIFY_EEPROM )
        add_custom_command(
            OUTPUT  "${executable}.eeprom.hex"
            COMMAND "${CMAKE_OBJCOPY}" -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0 "${executable}" "${executable}.eeprom.hex"
            DEPENDS "${executable}"
        )
        add_custom_target(
            "${executable}-hex-eeprom" ALL
            DEPENDS "${executable}.eeprom.hex"
        )
    endif( DEFINED add_avrdude_programming_targets_PROGRAM_EEPROM OR DEFINED add_avrdude_programming_targets_VERIFY_EEPROM )

    set( avrdude_common_arguments "" )

    if( DEFINED add_avrdude_programming_targets_CONFIGURATION_FILE )
        list( APPEND avrdude_common_arguments "-C" "${add_avrdude_programming_targets_CONFIGURATION_FILE}" )
    endif( DEFINED add_avrdude_programming_targets_CONFIGURATION_FILE )

    if( DEFINED add_avrdude_programming_targets_PORT )
        list( APPEND avrdude_common_arguments "-P" "${add_avrdude_programming_targets_PORT}" )
    endif( DEFINED add_avrdude_programming_targets_PORT )

    if( DEFINED add_avrdude_programming_targets_VERBOSITY )
        if( "${add_avrdude_programming_targets_VERBOSITY}" STREQUAL "VERY_QUIET" )
            list( APPEND avrdude_common_arguments "-q" "-q" )
        elseif( "${add_avrdude_programming_targets_VERBOSITY}" STREQUAL "QUIET" )
            list( APPEND avrdude_common_arguments "-q" )
        elseif( "${add_avrdude_programming_targets_VERBOSITY}" STREQUAL "VERBOSE" )
            list( APPEND avrdude_common_arguments "-v" )
        elseif( "${add_avrdude_programming_targets_VERBOSITY}" STREQUAL "VERY_VERBOSE" )
            list( APPEND avrdude_common_arguments "-v" "-v" )
        else( "${add_avrdude_programming_targets_VERBOSITY}" STREQUAL "VERY_QUIET" )
            message( FATAL_ERROR "'${add_avrdude_programming_targets_VERBOSITY}' is not a supported verbosity" )
        endif( "${add_avrdude_programming_targets_VERBOSITY}" STREQUAL "VERY_QUIET" )
    endif( DEFINED add_avrdude_programming_targets_VERBOSITY )

    if( DEFINED add_avrdude_programming_targets_PROGRAM_FLASH )
        add_custom_target(
            "${executable}-program-flash"
            COMMAND "${CMAKE_AVRDUDE}" ${avrdude_common_arguments} "-U" "flash:w:${executable}.flash.hex:i" ${add_avrdude_programming_targets_PROGRAM_FLASH}
            DEPENDS "${executable}.flash.hex"
        )
    endif( DEFINED add_avrdude_programming_targets_PROGRAM_FLASH )

    if( DEFINED add_avrdude_programming_targets_VERIFY_FLASH )
        add_custom_target(
            "${executable}-verify-flash"
            COMMAND "${CMAKE_AVRDUDE}" ${avrdude_common_arguments} "-U" "flash:v:${executable}.flash.hex:i" ${add_avrdude_programming_targets_VERIFY_FLASH}
            DEPENDS "${executable}.flash.hex"
        )
    endif( DEFINED add_avrdude_programming_targets_VERIFY_FLASH )

    if( DEFINED add_avrdude_programming_targets_PROGRAM_EEPROM )
        add_custom_target(
            "${executable}-program-eeprom"
            COMMAND "${CMAKE_AVRDUDE}" ${avrdude_common_arguments} "-U" "eeprom:w:${executable}.eeprom.hex:i" ${add_avrdude_programming_targets_PROGRAM_EEPROM}
            DEPENDS "${executable}.eeprom.hex"
        )
    endif( DEFINED add_avrdude_programming_targets_PROGRAM_EEPROM )

    if( DEFINED add_avrdude_programming_targets_VERIFY_EEPROM )
        add_custom_target(
            "${executable}-verify-eeprom"
            COMMAND "${CMAKE_AVRDUDE}" ${avrdude_common_arguments} "-U" "eeprom:v:${executable}.eeprom.hex:i" ${add_avrdude_programming_targets_VERIFY_EEPROM}
            DEPENDS "${executable}.eeprom.hex"
        )
    endif( DEFINED add_avrdude_programming_targets_VERIFY_EEPROM )
endfunction( add_avrdude_programming_targets )
