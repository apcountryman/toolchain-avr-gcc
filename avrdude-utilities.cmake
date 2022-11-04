# toolchain-avr-gcc
#
# Copyright 2019-2022, Andrew Countryman <apcountryman@gmail.com> and the
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

# File: avrdude-utilities.cmake
# Description: CMake avrdude utilities.

set( TOOLCHAIN_AVR_GCC_DIR "${CMAKE_CURRENT_LIST_DIR}" )

find_program( CMAKE_AVRDUDE avrdude )
mark_as_advanced( CMAKE_AVRDUDE )
if( "${CMAKE_AVRDUDE}" STREQUAL "CMAKE_AVRDUDE-NOTFOUND" )
    message( FATAL_ERROR "avrdude not found" )
endif( "${CMAKE_AVRDUDE}" STREQUAL "CMAKE_AVRDUDE-NOTFOUND" )

# Add avrdude target.
#
# SYNOPSIS
#     add_avrdude_target(
#         <target>
#         [DEPENDS <dependency>...]
#         [RESET]
#         [CONFIGURATION_FILE <configuration_file>]
#         [PORT <port>]
#         [VERBOSITY VERY_QUIET|QUIET|VERBOSE|VERY_VERBOSE]
#         [ARGUMENTS <avrdude_argument>...]
#     )
# OPTIONS
#     <target>
#         Specify the name of the created avrdude target.
#     ARGUMENTS <avrdude_argument>...
#         Specify the other avrdude arguments used by the target.
#     CONFIGURATION_FILE <configuration_file>
#         Specify the location of the avrdude configuration file. Equivalent to avrdude's
#         "-C <configuration_file>" option.
#     DEPENDS <dependency>...
#         Specify the target's dependencies.
#     PORT <port>
#         Specify the port the AVR is connected to. Equivalent to avrdude's "-P <port>"
#         option.
#     RESET
#         Reset the AVR before executing avrdude by opening the port the AVR is connected
#         to at 1200 bits/second, and then closing the port.
#     VERBOSITY VERY_QUIET|QUIET|VERBOSE|VERY_VERBOSE
#         Specify avrdude's output verbosity. "VERY_QUIET" is equivalent to avrdude's "-q
#         -q" option. "QUIET" is equivalent to avrdude's "-q" option. "VERBOSE" is
#         equivalent to avrdude's "-v" option. "VERY_VERBOSE" is equivalent to avrdude's
#         "-v -v" option.
# EXAMPLES
#    add_avrdude_target(
#        example-program-fuses
#        RESET
#        PORT      /dev/ttyACM0
#        VERBOSITY VERY_VERBOSE
#        ARGUMENTS -p atmega4809 -c jtag2updi -b 115200 -U fuse2:w:0x01:m -U
#            fuse5:w:0xC9:m -U fuse8:w:0x00:m
#    )
function( add_avrdude_target target )
    cmake_parse_arguments(
        add_avrdude_target
        "RESET"
        "CONFIGURATION_FILE;PORT;VERBOSITY"
        "ARGUMENTS;DEPENDS"
        ${ARGN}
    )

    if( DEFINED add_avrdude_target_UNPARSED_ARGUMENTS )
        message(
            FATAL_ERROR
            "'${add_avrdude_target_UNPARSED_ARGUMENTS}' are not supported arguments"
        )
    endif( DEFINED add_avrdude_target_UNPARSED_ARGUMENTS )

    set( reset_arguments   "" )
    set( avrdude_arguments "" )

    if( DEFINED add_avrdude_target_CONFIGURATION_FILE )
        list( APPEND avrdude_arguments "-C" "${add_avrdude_target_CONFIGURATION_FILE}" )
    endif( DEFINED add_avrdude_target_CONFIGURATION_FILE )

    if( DEFINED add_avrdude_target_PORT )
        list( APPEND reset_arguments        "${add_avrdude_target_PORT}" )
        list( APPEND avrdude_arguments "-P" "${add_avrdude_target_PORT}" )
    endif( DEFINED add_avrdude_target_PORT )

    if( DEFINED add_avrdude_target_VERBOSITY )
        if( "${add_avrdude_target_VERBOSITY}" STREQUAL "VERY_QUIET" )
            list( APPEND avrdude_arguments "-q" "-q" )
        elseif( "${add_avrdude_target_VERBOSITY}" STREQUAL "QUIET" )
            list( APPEND avrdude_arguments "-q" )
        elseif( "${add_avrdude_target_VERBOSITY}" STREQUAL "VERBOSE" )
            list( APPEND avrdude_arguments "-v" )
        elseif( "${add_avrdude_target_VERBOSITY}" STREQUAL "VERY_VERBOSE" )
            list( APPEND avrdude_arguments "-v" "-v" )
        else( "${add_avrdude_target_VERBOSITY}" STREQUAL "VERY_QUIET" )
            message( FATAL_ERROR "'${add_avrdude_target_VERBOSITY}' is not a supported verbosity" )
        endif( "${add_avrdude_target_VERBOSITY}" STREQUAL "VERY_QUIET" )
    endif( DEFINED add_avrdude_target_VERBOSITY )

    list( APPEND avrdude_arguments ${add_avrdude_target_ARGUMENTS} )

    if( ${add_avrdude_target_RESET} )
        add_custom_target(
            "${target}"
            COMMAND "${TOOLCHAIN_AVR_GCC_DIR}/utility/reset.py" ${reset_arguments}
            COMMAND "${CMAKE_AVRDUDE}" ${avrdude_arguments}
            DEPENDS ${add_avrdude_target_DEPENDS}
        )
    else( ${add_avrdude_target_RESET} )
        add_custom_target(
            "${target}"
            COMMAND "${CMAKE_AVRDUDE}" ${avrdude_arguments}
            DEPENDS ${add_avrdude_target_DEPENDS}
        )
    endif( ${add_avrdude_target_RESET} )
endfunction( add_avrdude_target target )

# Add avrdude programming targets for an executable.
#
# SYNOPSIS
#     add_avrdude_programming_targets(
#         <executable>
#         [RESET]
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
#     RESET
#         Reset the AVR before executing avrdude by opening the port the AVR is connected
#         to at 1200 bits/second, and then closing the port.
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
#     add_avrdude_programming_targets(
#         example
#         RESET
#         PORT          /dev/ttyACM0
#         VERBOSITY     VERY_VERBOSE
#         PROGRAM_FLASH -p atmega4809 -c jtag2updi -b 115200 -e -D
#         VERIFY_FLASH  -p atmega4809 -c jtag2updi -b 115200
#     )
function( add_avrdude_programming_targets executable )
    if( "${CMAKE_AVRDUDE}" STREQUAL "CMAKE_AVRDUDE-NOTFOUND" )
        message( FATAL_ERROR "avrdude not found" )
    endif( "${CMAKE_AVRDUDE}" STREQUAL "CMAKE_AVRDUDE-NOTFOUND" )

    cmake_parse_arguments(
        add_avrdude_programming_targets
        "RESET"
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

    if( ${add_avrdude_programming_targets_RESET} )
        set( reset "RESET" )
    endif( ${add_avrdude_programming_targets_RESET} )

    if( DEFINED add_avrdude_programming_targets_PROGRAM_FLASH )
        add_avrdude_target(
            "${executable}-program-flash"
            DEPENDS "${executable}.flash.hex"
            ${reset}
            CONFIGURATION_FILE "${add_avrdude_programming_targets_CONFIGURATION_FILE}"
            PORT               "${add_avrdude_programming_targets_PORT}"
            VERBOSITY          "${add_avrdude_programming_targets_VERBOSITY}"
            ARGUMENTS          "-U" "flash:w:${executable}.flash.hex:i" ${add_avrdude_programming_targets_PROGRAM_FLASH}
        )
    endif( DEFINED add_avrdude_programming_targets_PROGRAM_FLASH )

    if( DEFINED add_avrdude_programming_targets_VERIFY_FLASH )
        add_avrdude_target(
            "${executable}-verify-flash"
            DEPENDS "${executable}.flash.hex"
            ${reset}
            CONFIGURATION_FILE "${add_avrdude_programming_targets_CONFIGURATION_FILE}"
            PORT               "${add_avrdude_programming_targets_PORT}"
            VERBOSITY          "${add_avrdude_programming_targets_VERBOSITY}"
            ARGUMENTS          "-U" "flash:v:${executable}.flash.hex:i" ${add_avrdude_programming_targets_VERIFY_FLASH}
        )
    endif( DEFINED add_avrdude_programming_targets_VERIFY_FLASH )

    if( DEFINED add_avrdude_programming_targets_PROGRAM_EEPROM )
        add_avrdude_target(
            "${executable}-program-eeprom"
            DEPENDS "${executable}.eeprom.hex"
            ${reset}
            CONFIGURATION_FILE "${add_avrdude_programming_targets_CONFIGURATION_FILE}"
            PORT               "${add_avrdude_programming_targets_PORT}"
            VERBOSITY          "${add_avrdude_programming_targets_VERBOSITY}"
            ARGUMENTS          "-U" "eeprom:w:${executable}.eeprom.hex:i" ${add_avrdude_programming_targets_PROGRAM_EEPROM}
        )
    endif( DEFINED add_avrdude_programming_targets_PROGRAM_EEPROM )

    if( DEFINED add_avrdude_programming_targets_VERIFY_EEPROM )
        add_avrdude_target(
            "${executable}-verify-eeprom"
            DEPENDS "${executable}.eeprom.hex"
            ${reset}
            CONFIGURATION_FILE "${add_avrdude_programming_targets_CONFIGURATION_FILE}"
            PORT               "${add_avrdude_programming_targets_PORT}"
            VERBOSITY          "${add_avrdude_programming_targets_VERBOSITY}"
            ARGUMENTS          "-U" "eeprom:v:${executable}.eeprom.hex:i" ${add_avrdude_programming_targets_VERIFY_EEPROM}
        )
    endif( DEFINED add_avrdude_programming_targets_VERIFY_EEPROM )
endfunction( add_avrdude_programming_targets )

# Add an avrdude programming target for an executable.
#
# SYNOPSIS
#     add_avrdude_programming_target(
#         <executable>
#         <target_postfix>
#         [RESET]
#         [CONFIGURATION_FILE <configuration_file>]
#         [PORT <port>]
#         [VERBOSITY VERY_QUIET|QUIET|VERBOSE|VERY_VERBOSE]
#         [OPERATIONS <memory_type>:<operation>...]
#         [ARGUMENTS <avrdude_argument>...]
#     )
# OPTIONS
#     <executable>
#         Specify the name of the executable that a programming target will be created
#         for.
#     <target_postfix>
#         Specify the postfix of the created avrdude programming target
#         ("<executable>-<target_postfix>").
#     ARGUMENTS <avrdude_argument>...
#         Specify the other avrdude arguments used by the target.
#     CONFIGURATION_FILE <configuration_file>
#         Specify the location of the avrdude configuration file. Equivalent to avrdude's
#         "-C <configuration_file>" option.
#     OPERATIONS <memory_type>:<operation>...
#         Specify the memory operations to perform. Equivalent to avrdude's "-U
#         <memory_type>:<operation>:<filename>[:format]" option, but only write and verify
#         operations are supported.
#     PORT <port>
#         Specify the port the AVR is connected to. Equivalent to avrdude's "-P <port>"
#         option.
#     RESET
#         Reset the AVR before executing avrdude by opening the port the AVR is connected
#         to at 1200 bits/second, and then closing the port.
#     VERBOSITY VERY_QUIET|QUIET|VERBOSE|VERY_VERBOSE
#         Specify avrdude's output verbosity. "VERY_QUIET" is equivalent to avrdude's "-q
#         -q" option. "QUIET" is equivalent to avrdude's "-q" option. "VERBOSE" is
#         equivalent to avrdude's "-v" option. "VERY_VERBOSE" is equivalent to avrdude's
#         "-v -v" option.
# EXAMPLES
#     add_avrdude_programming_target(
#         example
#         program-flash-eeprom
#         PORT       /dev/ttyACM0
#         VERBOSITY  VERY_VERBOSE
#         OPERATIONS flash:w eeprom:w
#         ARGUMENTS  -p atmega2560 -c wiring -b 115200 -D
#     )
#     add_avrdude_programming_target(
#         example
#         program-flash-eeprom
#         PORT       /dev/ttyACM0
#         VERBOSITY  VERY_VERBOSE
#         OPERATIONS flash:w eeprom:w
#         ARGUMENTS  -p atmega328p -c arduino -b 115200 -D
#     )
#     add_avrdude_programming_target(
#         example
#         program-flash-eeprom
#         RESET
#         PORT       /dev/ttyACM0
#         VERBOSITY  VERY_VERBOSE
#         OPERATIONS flash:w eeprom:w
#         ARGUMENTS  -p atmega4809 -c jtag2updi -b 115200 -e -D
#     )
function( add_avrdude_programming_target executable target_postfix )
    cmake_parse_arguments(
        add_avrdude_programming_target
        "RESET"
        "CONFIGURATION_FILE;PORT;VERBOSITY"
        "ARGUMENTS;OPERATIONS"
        ${ARGN}
    )

    if( DEFINED add_avrdude_programming_target_UNPARSED_ARGUMENTS )
        message(
            FATAL_ERROR
            "'${add_avrdude_programming_target_UNPARSED_ARGUMENTS}' are not supported arguments"
        )
    endif( DEFINED add_avrdude_programming_target_UNPARSED_ARGUMENTS )

    if( ${add_avrdude_programming_target_RESET} )
        set( reset "RESET" )
    endif( ${add_avrdude_programming_target_RESET} )

    set( operations "" )
    foreach( operation ${add_avrdude_programming_target_OPERATIONS} )
        list( APPEND operations "-U" "${operation}:${executable}:e" )
    endforeach( operation ${add_avrdude_programming_target_OPERATIONS} )

    add_avrdude_target(
        "${executable}-${target_postfix}"
        DEPENDS "${executable}"
        ${reset}
        CONFIGURATION_FILE "${add_avrdude_programming_target_CONFIGURATION_FILE}"
        PORT               "${add_avrdude_programming_target_PORT}"
        VERBOSITY          "${add_avrdude_programming_target_VERBOSITY}"
        ARGUMENTS          ${add_avrdude_programming_target_ARGUMENTS} ${operations}
    )
endfunction( add_avrdude_programming_target )

# Add avrdude flash programming targets for an executable.
#
# SYNOPSIS
#     add_avrdude_flash_programming_targets(
#         <executable>
#         [RESET]
#         [CONFIGURATION_FILE <configuration_file>]
#         [PORT <port>]
#         [VERBOSITY VERY_QUIET|QUIET|VERBOSE|VERY_VERBOSE]
#         [PROGRAM <avrdude_argument>...]
#         [VERIFY <avrdude_argument>...]
#     )
# OPTIONS
#     <executable>
#         Specify the name of the executable that programming targets
#         ("<executable>-program-flash" and "<executable>-verify-flash") will be created
#         for.
#     CONFIGURATION_FILE <configuration_file>
#         Specify the location of the avrdude configuration file. Equivalent to avrdude's
#         "-C <configuration_file>" option.
#     PORT <port>
#         Specify the port the AVR is connected to. Equivalent to avrdude's "-P <port>"
#         option.
#     PROGRAM <avrdude_argument>...
#         Specify the other avrdude arguments used by the "<executable>-program-flash"
#         target.
#     RESET
#         Reset the AVR before executing avrdude by opening the port the AVR is connected
#         to at 1200 bits/second, and then closing the port.
#     VERBOSITY VERY_QUIET|QUIET|VERBOSE|VERY_VERBOSE
#         Specify avrdude's output verbosity. "VERY_QUIET" is equivalent to avrdude's "-q
#         -q" option. "QUIET" is equivalent to avrdude's "-q" option. "VERBOSE" is
#         equivalent to avrdude's "-v" option. "VERY_VERBOSE" is equivalent to avrdude's
#         "-v -v" option.
#     VERIFY <avrdude_argument>...
#         Specify the other avrdude arguments used by the "<executable>-verify-flash"
#         target.
# EXAMPLES
#     add_avrdude_flash_programming_targets(
#         example
#         PORT      /dev/ttyACM0
#         VERBOSITY VERY_VERBOSE
#         PROGRAM   -p atmega2560 -c wiring -b 115200 -D
#         VERIFY    -p atmega2560 -c wiring -b 115200
#     )
#     add_avrdude_flash_programming_targets(
#         example
#         PORT      /dev/ttyACM0
#         VERBOSITY VERY_VERBOSE
#         PROGRAM   -p atmega328p -c arduino -b 115200 -D
#         VERIFY    -p atmega328p -c arduino -b 115200
#     )
#     add_avrdude_flash_programming_targets(
#         example
#         RESET
#         PORT      /dev/ttyACM0
#         VERBOSITY VERY_VERBOSE
#         PROGRAM   -p atmega4809 -c jtag2updi -b 115200 -e -D
#         VERIFY    -p atmega4809 -c jtag2updi -b 115200
#     )
function( add_avrdude_flash_programming_targets executable )
    cmake_parse_arguments(
        add_avrdude_flash_programming_targets
        "RESET"
        "CONFIGURATION_FILE;PORT;VERBOSITY"
        "PROGRAM;VERIFY"
        ${ARGN}
    )

    if( DEFINED add_avrdude_flash_programming_targets_UNPARSED_ARGUMENTS )
        message(
            FATAL_ERROR
            "'${add_avrdude_flash_programming_targets_UNPARSED_ARGUMENTS}' are not supported arguments"
        )
    endif( DEFINED add_avrdude_flash_programming_targets_UNPARSED_ARGUMENTS )

    if( ${add_avrdude_flash_programming_targets_RESET} )
        set( reset "RESET" )
    endif( ${add_avrdude_flash_programming_targets_RESET} )

    add_avrdude_programming_target(
        "${executable}"
        "program-flash"
        ${reset}
        CONFIGURATION_FILE "${add_avrdude_flash_programming_targets_CONFIGURATION_FILE}"
        PORT               "${add_avrdude_flash_programming_targets_PORT}"
        VERBOSITY          "${add_avrdude_flash_programming_targets_VERBOSITY}"
        OPERATIONS         "flash:w"
        ARGUMENTS          ${add_avrdude_flash_programming_targets_PROGRAM}
    )
    add_avrdude_programming_target(
        "${executable}"
        "verify-flash"
        ${reset}
        CONFIGURATION_FILE "${add_avrdude_flash_programming_targets_CONFIGURATION_FILE}"
        PORT               "${add_avrdude_flash_programming_targets_PORT}"
        VERBOSITY          "${add_avrdude_flash_programming_targets_VERBOSITY}"
        OPERATIONS         "flash:v"
        ARGUMENTS          ${add_avrdude_flash_programming_targets_VERIFY}
    )
endfunction( add_avrdude_flash_programming_targets )
