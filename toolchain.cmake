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

# Add avrdude programming targets for an executable. The following targets will be
# created:
#     <executable>-hex-flash
#         Creates the <executable>.flash.hex file used during Flash programming and
#         verification. This target is added to ALL.
#     <executable>-program-flash
#         Program the Flash.
#     <executable>-verify-flash
#         Verify the Flash.
#     <executable>-hex-eeprom
#         Creates the <executable>.eeprom.hex file used during EEPROM programming and
#         verification. This target is added to ALL.
#     <executable>-program-eeprom
#         Program the EEPROM.
#     <executable>-verify-eeprom
#         Verify the EEPROM.
# SYNOPSIS
#     add_avrdude_programming_targets(
#         <executable>
#         PART <part>
#         PROGRAMMER <programmer>
#         [ALWAYS_RECOVER_FUSES]
#         [DISABLE_AUTOMATIC_FLASH_ERASE]
#         [DISABLE_AUTOMATIC_VERIFY]
#         [DISABLE_FUSE_CHECKS]
#         [DISABLE_WRITES]
#         [ERASE_CHIP]
#         [OVERRIDE_SIGNATURE_CHECK]
#         [BAUD_RATE <baud_rate>]
#         [BIT_CLOCK <bit_clock>]
#         [CONFIGURATION_FILE <configuration_file>]
#         [DELAY <delay>]
#         [EXIT_SPECIFICATION <exit_specification>]
#         [EXTENDED_PARAMETERS <extended_parameters>]
#         [PORT <port>]
#         [VERBOSITY VERY_QUIET|QUIET|VERBOSE|VERY_VERBOSE]
#         [MEMORY_OPERATIONS_POST_FLASH_PROGRAM <memory_operation>...]
#         [MEMORY_OPERATIONS_PRE_FLASH_PROGRAM <memory_operation>...]
#     )
# OPTIONS
#     <executable>
#         The name of the executable to add programming targets for.
#     ALWAYS_RECOVER_FUSES
#         Equivalent to avrdude's "-s" option. Only affects "-program-" targets.
#     BAUD_RATE <baud_rate>
#         Equivalent to avrdude's "-b <baud_rate>" option.
#     BIT_CLOCK <bit_clock>
#         Equivalent to avrdude's "-B <bit_clock>" option.
#     CONFIGURATION_FILE <configuration_file>
#         Equivalent to avrdude's "-C <configuration_file>" option.
#     DELAY <delay>
#         Equivalent to avrdude's "-i <delay>" option.
#     DISABLE_AUTOMATIC_FLASH_ERASE
#         Equivalent to avrdude's "-D" option. Only affects the "-program-flash" target.
#     DISABLE_AUTOMATIC_VERIFY
#         Equivalent to avrdude's "-V" option. Only affects "-program-" targets.
#     DISABLE_FUSE_CHECKS
#         Equivalent to avrdude's "-u" option. Only affects "-program-" targets.
#     DISABLE_WRITES
#         Equivalent to avrdude's "-n" option. Only affects "-program-" targets.
#     ERASE_CHIP
#         Equivalent to avrdude's "-e" option. Only affects the "-program-flash" target.
#     EXIT_SPECIFICATION <exit_specification>
#         Equivalent to avrdude's "-E <exit_specification>" option.
#     EXTENDED_PARAMETERS <extended_parameters>
#         Equivalent to avrdude's "-x <extended_parameters>" option.
#     MEMORY_OPERATIONS_POST_FLASH_PROGRAM <memory_operation>...
#         Equivalent to avrdude's "-U <memtype>:r|w|v:<filename>[:format]" option. Only
#         affects the "-program-flash" target. Memory operations will be performed after
#         the memory operation that programs the Flash.
#     MEMORY_OPERATIONS_PRE_FLASH_PROGRAM <memory_operation>...
#         Equivalent to avrdude's "-U <memtype>:r|w|v:<filename>[:format]" option. Only
#         affects the "-program-flash" target. Memory operations will be performed before
#         the memory operation that programs the Flash.
#     OVERRIDE_SIGNATURE_CHECK
#         Equivalent to avrdude's "-F" option.
#     PART <part>
#         Equivalent to avrdude's "-p <part>" option.
#     PORT <port>
#         Equivalent to avrdude's "-P <port>" option.
#     PROGRAMMER <programmer>
#         Equivalent to avrdude's "-c <programmer>" option.
#     VERBOSITY VERY_QUIET|QUIET|VERBOSE|VERY_VERBOSE
#         VERY_QUIET is equivalent to avrdude's "-q -q" option. QUIET is equivalent to
#         avrdude's "-q" option. VERBOSE is equivalent to avrdude's "-v" option.
#         VERY_VERBOSE is equivalent to avrdude's "-v -v" option.
# EXAMPLES
#     add_avrdude_programming_targets(
#         example
#         DISABLE_AUTOMATIC_FLASH_ERASE
#         BAUD_RATE  115200
#         PART       atmega328p
#         PORT       /dev/ttyACM0
#         PROGRAMMER arduino
#         VERBOSITY  VERBOSE
#     )
#     add_avrdude_programming_targets(
#         example
#         DISABLE_AUTOMATIC_FLASH_ERASE
#         BAUD_RATE  115200
#         PART       atmega2560
#         PORT       /dev/ttyACM0
#         PROGRAMMER wiring
#         VERBOSITY  VERBOSE
#     )
function( add_avrdude_programming_targets executable )
    if( "${CMAKE_AVRDUDE}" STREQUAL "CMAKE_AVRDUDE-NOTFOUND" )
        message( FATAL_ERROR "avrdude not found" )
    endif( "${CMAKE_AVRDUDE}" STREQUAL "CMAKE_AVRDUDE-NOTFOUND" )

    cmake_parse_arguments(
        add_avrdude_programming_targets
        "ALWAYS_RECOVER_FUSES;DISABLE_AUTOMATIC_FLASH_ERASE;DISABLE_AUTOMATIC_VERIFY;DISABLE_FUSE_CHECKS;DISABLE_WRITES;ERASE_CHIP;OVERRIDE_SIGNATURE_CHECK"
        "BAUD_RATE;BIT_CLOCK;CONFIGURATION_FILE;DELAY;EXIT_SPECIFICATION;EXTENDED_PARAMETERS;PART;PORT;PROGRAMMER;VERBOSITY"
        "MEMORY_OPERATIONS_PRE_FLASH_PROGRAM;MEMORY_OPERATIONS_POST_FLASH_PROGRAM"
        ${ARGN}
    )

    if( add_avrdude_programming_targets_UNPARSED_ARGUMENTS )
        message(
            FATAL_ERROR
            "'${add_avrdude_programming_targets_UNPARSED_ARGUMENTS}' are not supported arguments"
        )
    endif( add_avrdude_programming_targets_UNPARSED_ARGUMENTS )

    add_custom_command(
        OUTPUT  "${executable}.flash.hex"
        COMMAND "${CMAKE_OBJCOPY}" -O ihex -R .eeprom "${executable}" "${executable}.flash.hex"
        DEPENDS "${executable}"
    )
    add_custom_target(
        "${executable}-hex-flash" ALL
        DEPENDS "${executable}.flash.hex"
    )

    add_custom_command(
        OUTPUT  "${executable}.eeprom.hex"
        COMMAND "${CMAKE_OBJCOPY}" -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0 "${executable}" "${executable}.eeprom.hex"
        DEPENDS "${executable}"
    )
    add_custom_target(
        "${executable}-hex-eeprom" ALL
        DEPENDS "${executable}.eeprom.hex"
    )

    set( avrdude_common_arguments         "" )
    set( avrdude_program_arguments        "" )
    set( avrdude_program_flash_arguments  "" )
    set( avrdude_program_eeprom_arguments "" )
    set( avrdude_verify_arguments         "" )
    set( avrdude_verify_flash_arguments   "" )
    set( avrdude_verify_eeprom_arguments  "" )

    if( ${add_avrdude_programming_targets_ALWAYS_RECOVER_FUSES} )
        list( APPEND avrdude_program_arguments "-s" )
    endif( ${add_avrdude_programming_targets_ALWAYS_RECOVER_FUSES} )

    if( ${add_avrdude_programming_targets_DISABLE_AUTOMATIC_FLASH_ERASE} )
        list( APPEND avrdude_program_flash_arguments "-D" )
    endif( ${add_avrdude_programming_targets_DISABLE_AUTOMATIC_FLASH_ERASE} )

    if( ${add_avrdude_programming_targets_DISABLE_AUTOMATIC_VERIFY} )
        list( APPEND avrdude_program_arguments "-V" )
    endif( ${add_avrdude_programming_targets_DISABLE_AUTOMATIC_VERIFY} )

    if( ${add_avrdude_programming_targets_DISABLE_FUSE_CHECKS} )
        list( APPEND avrdude_program_arguments "-u" )
    endif( ${add_avrdude_programming_targets_DISABLE_FUSE_CHECKS} )

    if( ${add_avrdude_programming_targets_DISABLE_WRITES} )
        list( APPEND avrdude_program_arguments "-n" )
    endif( ${add_avrdude_programming_targets_DISABLE_WRITES} )

    if( ${add_avrdude_programming_targets_ERASE_CHIP} )
        list( APPEND avrdude_program_flash_arguments "-e" )
    endif( ${add_avrdude_programming_targets_ERASE_CHIP} )

    if( ${add_avrdude_programming_targets_OVERRIDE_SIGNATURE_CHECK} )
        list( APPEND avrdude_common_arguments "-F" )
    endif( ${add_avrdude_programming_targets_OVERRIDE_SIGNATURE_CHECK} )

    if( add_avrdude_programming_targets_BAUD_RATE )
        list( APPEND avrdude_common_arguments "-b" "${add_avrdude_programming_targets_BAUD_RATE}" )
    endif( add_avrdude_programming_targets_BAUD_RATE )

    if( add_avrdude_programming_targets_BIT_CLOCK )
        list( APPEND avrdude_common_arguments "-B" "${add_avrdude_programming_targets_BIT_CLOCK}" )
    endif( add_avrdude_programming_targets_BIT_CLOCK )

    if( add_avrdude_programming_targets_CONFIGURATION_FILE )
        list( APPEND avrdude_common_arguments "-C" "${add_avrdude_programming_targets_CONFIGURATION_FILE}" )
    endif( add_avrdude_programming_targets_CONFIGURATION_FILE )

    if( add_avrdude_programming_targets_DELAY )
        list( APPEND avrdude_common_arguments "-i" "${add_avrdude_programming_targets_DELAY}" )
    endif( add_avrdude_programming_targets_DELAY )

    if( add_avrdude_programming_targets_EXIT_SPECIFICATION )
        list( APPEND avrdude_common_arguments "-E" "${add_avrdude_programming_targets_EXIT_SPECIFICATION}" )
    endif( add_avrdude_programming_targets_EXIT_SPECIFICATION )

    if( add_avrdude_programming_targets_EXTENDED_PARAMETERS )
        list( APPEND avrdude_common_arguments "-x" "${add_avrdude_programming_targets_EXTENDED_PARAMETERS}" )
    endif( add_avrdude_programming_targets_EXTENDED_PARAMETERS )

    if( add_avrdude_programming_targets_PART )
        list( APPEND avrdude_common_arguments "-p" "${add_avrdude_programming_targets_PART}" )
    else( add_avrdude_programming_targets_PART )
        message( FATAL_ERROR "'PART' not specified" )
    endif( add_avrdude_programming_targets_PART )

    if( add_avrdude_programming_targets_PORT )
        list( APPEND avrdude_common_arguments "-P" "${add_avrdude_programming_targets_PORT}" )
    endif( add_avrdude_programming_targets_PORT )

    if( add_avrdude_programming_targets_PROGRAMMER )
        list( APPEND avrdude_common_arguments "-c" "${add_avrdude_programming_targets_PROGRAMMER}" )
    else( add_avrdude_programming_targets_PROGRAMMER )
        message( FATAL_ERROR "'PROGRAMMER' not specified" )
    endif( add_avrdude_programming_targets_PROGRAMMER )

    if( add_avrdude_programming_targets_VERBOSITY )
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
    endif( add_avrdude_programming_targets_VERBOSITY )

    list( APPEND avrdude_program_flash_arguments  ${avrdude_common_arguments} ${avrdude_program_arguments} )
    list( APPEND avrdude_program_eeprom_arguments ${avrdude_common_arguments} ${avrdude_program_arguments} )
    list( APPEND avrdude_verify_flash_arguments   ${avrdude_common_arguments} ${avrdude_verify_arguments}  )
    list( APPEND avrdude_verify_eeprom_arguments  ${avrdude_common_arguments} ${avrdude_verify_arguments}  )

    if ( add_avrdude_programming_targets_MEMORY_OPERATIONS_PRE_FLASH_PROGRAM )
        foreach( memory_operation IN LISTS add_avrdude_programming_targets_MEMORY_OPERATIONS_PRE_FLASH_PROGRAM )
            list( APPEND avrdude_program_flash_arguments "-U" "${memory_operation}" )
        endforeach()
    endif ( add_avrdude_programming_targets_MEMORY_OPERATIONS_PRE_FLASH_PROGRAM )

    list( APPEND avrdude_program_flash_arguments  "-U" "flash:w:${executable}.flash.hex:i"   )
    list( APPEND avrdude_program_eeprom_arguments "-U" "flash:v:${executable}.flash.hex:i"   )
    list( APPEND avrdude_verify_flash_arguments   "-U" "eeprom:w:${executable}.eeprom.hex:i" )
    list( APPEND avrdude_verify_eeprom_arguments  "-U" "eeprom:v:${executable}.eeprom.hex:i" )

    if ( add_avrdude_programming_targets_MEMORY_OPERATIONS_POST_FLASH_PROGRAM )
        foreach( memory_operation IN LISTS add_avrdude_programming_targets_MEMORY_OPERATIONS_POST_FLASH_PROGRAM )
            list( APPEND avrdude_program_flash_arguments "-U" "${memory_operation}" )
        endforeach()
    endif ( add_avrdude_programming_targets_MEMORY_OPERATIONS_POST_FLASH_PROGRAM )

    add_custom_target(
        "${executable}-program-flash"
        COMMAND "${CMAKE_AVRDUDE}" ${avrdude_program_flash_arguments}
        DEPENDS "${executable}.flash.hex"
    )
    add_custom_target(
        "${executable}-verify-flash"
        COMMAND "${CMAKE_AVRDUDE}" ${avrdude_verify_flash_arguments}
        DEPENDS "${executable}.flash.hex"
    )

    add_custom_target(
        "${executable}-program-eeprom"
        COMMAND "${CMAKE_AVRDUDE}" ${avrdude_program_eeprom_arguments}
        DEPENDS "${executable}.eeprom.hex"
    )
    add_custom_target(
        "${executable}-verify-eeprom"
        COMMAND "${CMAKE_AVRDUDE}" ${avrdude_verify_eeprom_arguments}
        DEPENDS "${executable}.eeprom.hex"
    )
endfunction( add_avrdude_programming_targets )
