# toolchain-avr-gcc
#
# Copyright 2019 Andrew Countryman <apcountryman@gmail.com>
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

# File: examples/CMakeLists.txt
# Description: toolchain-avr-gcc examples CMake rules.

cmake_minimum_required( VERSION 3.13.4 )
project(
    examples-toolchain-avr-gcc
    LANGUAGES C CXX
)

# ensure avrdude was found
if( CMAKE_AVRDUDE STREQUAL "CMAKE_AVRDUDE-NOTFOUND" )
    message( FATAL_ERROR "avrdude not found" )
endif( CMAKE_AVRDUDE STREQUAL "CMAKE_AVRDUDE-NOTFOUND" )

# Atmel AVR configuration
set( ATMEL_AVR_MCU   "" CACHE STRING "Atmel AVR: MCU"                  )
set( ATMEL_AVR_F_CPU "" CACHE STRING "Atmel AVR: MCU frequency, in Hz" )

# avrdude configuration
option( AVRDUDE_ALWAYS_RECOVER_FUSES_ENABLED          OFF "avrdude: always recover fuses"          )
option( AVRDUDE_DISABLE_AUTOMATIC_FLASH_ERASE_ENABLED OFF "avrdude: disable automatic Flash erase" )
option( AVRDUDE_DISABLE_AUTOMATIC_VERIFY_ENABLED      OFF "avrdude: disable automatic verify"      )
option( AVRDUDE_DISABLE_FUSE_CHECKS_ENABLED           OFF "avrdude: disable fuse checks"           )
option( AVRDUDE_DISABLE_WRITES_ENABLED                OFF "avrdude: disable writes"                )
option( AVRDUDE_OVERRIDE_SIGNATURE_CHECK_ENABLED      OFF "avrdude: override signature check"      )
mark_as_advanced(
    AVRDUDE_ALWAYS_RECOVER_FUSES_ENABLED
    AVRDUDE_DISABLE_AUTOMATIC_FLASH_ERASE_ENABLED
    AVRDUDE_DISABLE_AUTOMATIC_VERIFY_ENABLED
    AVRDUDE_DISABLE_FUSE_CHECKS_ENABLED
    AVRDUDE_DISABLE_WRITES_ENABLED
    AVRDUDE_OVERRIDE_SIGNATURE_CHECK_ENABLED
)

set( AVRDUDE_BAUD_RATE           ""        CACHE STRING "avrdude: baud rate"           )
set( AVRDUDE_BIT_CLOCK           ""        CACHE STRING "avrdude: bit clock"           )
set( AVRDUDE_CONFIGURATION_FILE  ""        CACHE STRING "avrdude: configuration file"  )
set( AVRDUDE_DELAY               ""        CACHE STRING "avrdude: delay"               )
set( AVRDUDE_EXIT_SPECIFICATION  ""        CACHE STRING "avrdude: exit specification"  )
set( AVRDUDE_EXTENDED_PARAMETERS ""        CACHE STRING "avrdude: extended parameters" )
set( AVRDUDE_PART                ""        CACHE STRING "avrdude: part"                )
set( AVRDUDE_PORT                ""        CACHE STRING "avrdude: port"                )
set( AVRDUDE_PROGRAMMER          ""        CACHE STRING "avrdude: programmer"          )
set( AVRDUDE_VERBOSITY           "VERBOSE" CACHE STRING "avrdude: verbosity"           )

if( AVRDUDE_ALWAYS_RECOVER_FUSES_ENABLED )
    set( AVRDUDE_ALWAYS_RECOVER_FUSES "ALWAYS_RECOVER_FUSES" )
endif( AVRDUDE_ALWAYS_RECOVER_FUSES_ENABLED )

if( AVRDUDE_DISABLE_AUTOMATIC_FLASH_ERASE_ENABLED )
    set( AVRDUDE_DISABLE_AUTOMATIC_FLASH_ERASE "DISABLE_AUTOMATIC_FLASH_ERASE" )
endif( AVRDUDE_DISABLE_AUTOMATIC_FLASH_ERASE_ENABLED )

if( AVRDUDE_DISABLE_AUTOMATIC_VERIFY_ENABLED )
    set( AVRDUDE_DISABLE_AUTOMATIC_VERIFY "DISABLE_AUTOMATIC_VERIFY" )
endif( AVRDUDE_DISABLE_AUTOMATIC_VERIFY_ENABLED )

if( AVRDUDE_DISABLE_FUSE_CHECKS_ENABLED )
    set( AVRDUDE_DISABLE_FUSE_CHECKS "DISABLE_FUSE_CHECKS" )
endif( AVRDUDE_DISABLE_FUSE_CHECKS_ENABLED )

if( AVRDUDE_DISABLE_WRITES_ENABLED )
    set( AVRDUDE_DISABLE_WRITES "DISABLE_WRITES" )
endif( AVRDUDE_DISABLE_WRITES_ENABLED )

if( AVRDUDE_OVERRIDE_SIGNATURE_CHECK_ENABLED )
    set( AVRDUDE_OVERRIDE_SIGNATURE_CHECK "OVERRIDE_SIGNATURE_CHECK" )
endif( AVRDUDE_OVERRIDE_SIGNATURE_CHECK_ENABLED )

# configure compilation and linking
set(
    CMAKE_C_FLAGS
    "${CMAKE_C_FLAGS} \
    -std=c17 \
    -Werror -Wall -Wextra \
    -Wpointer-arith -Wstrict-prototypes \
    -mmcu=${ATMEL_AVR_MCU} \
    -DF_CPU=${ATMEL_AVR_F_CPU}UL \
    "
)
set(
    CMAKE_CXX_FLAGS
    "${CMAKE_CXX_FLAGS} \
    -std=c++17 \
    -Werror -Wall -Wextra \
    -Wpointer-arith -Wold-style-cast \
    -mmcu=${ATMEL_AVR_MCU} \
    -DF_CPU=${ATMEL_AVR_F_CPU} \
    "
)
