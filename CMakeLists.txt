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

# File: CMakeLists.txt
# Description: toolchain-avr-gcc core CMake rules.

cmake_minimum_required( VERSION 3.13.4 )
project(
    toolchain-avr-gcc
    LANGUAGES C CXX
)

# Microchip AVR configuration
set( MICROCHIP_AVR_MCU   "" CACHE STRING "Microchip AVR: MCU"                  )
set( MICROCHIP_AVR_F_CPU "" CACHE STRING "Microchip AVR: MCU frequency, in Hz" )

# avrdude configuration
option( AVRDUDE_RESET_ENABLED "avrdude: reset AVR before executing avrdude" OFF )

set( AVRDUDE_CONFIGURATION_FILE  ""        CACHE STRING "avrdude: configuration file"                   )
set( AVRDUDE_PORT                ""        CACHE STRING "avrdude: port"                                 )
set( AVRDUDE_PROGRAM_FLASH       ""        CACHE STRING "avrdude: flash programming avrdude arguments"  )
set( AVRDUDE_VERBOSITY           "VERBOSE" CACHE STRING "avrdude: verbosity"                            )
set( AVRDUDE_VERIFY_FLASH        ""        CACHE STRING "avrdude: flash verification avrdude arguments" )

if( ${AVRDUDE_RESET_ENABLED} )
    set( AVRDUDE_RESET "RESET" )
endif( ${AVRDUDE_RESET_ENABLED} )

# configure compilation and linking
set(
    CMAKE_C_FLAGS
    "${CMAKE_C_FLAGS} \
    -std=c17 \
    -Werror -Wall -Wextra \
    -Wcast-align=strict \
    -Wcast-qual \
    -Wduplicated-cond \
    -Wfloat-equal \
    -Wimplicit-fallthrough=5 \
    -Wlogical-op \
    -Wmissing-field-initializers \
    -Wmissing-include-dirs \
    -Wpointer-arith \
    -Wshadow \
    -Wstrict-prototypes \
    -Wunsafe-loop-optimizations \
    -mmcu=${MICROCHIP_AVR_MCU} \
    -DF_CPU=${MICROCHIP_AVR_F_CPU}UL \
    "
)
set( CMAKE_CXX_STANDARD 17 )
set(
    CMAKE_CXX_FLAGS
    "${CMAKE_CXX_FLAGS} \
    -Werror -Wall -Wextra \
    -Wcast-align=strict \
    -Wcast-qual \
    -Wduplicated-cond \
    -Wextra-semi \
    -Wfloat-equal \
    -Wimplicit-fallthrough=5 \
    -Wlogical-op \
    -Wmissing-field-initializers \
    -Wmissing-include-dirs \
    -Wold-style-cast \
    -Wplacement-new=2 \
    -Wpointer-arith \
    -Wshadow \
    -Wunsafe-loop-optimizations \
    -mmcu=${MICROCHIP_AVR_MCU} \
    -DF_CPU=${MICROCHIP_AVR_F_CPU} \
    "
)

# build the toolchain's examples
add_subdirectory( examples )
