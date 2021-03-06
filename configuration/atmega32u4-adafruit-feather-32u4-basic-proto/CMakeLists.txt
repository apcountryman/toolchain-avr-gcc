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

# File: configuration/atmega32u4-adafruit-feather-32u4-basic-proto/CMakeLists.txt
# Description: ATmega32U4 Adafruit Feather 32u4 Basic Proto toolchain-avr-gcc
#       configuration.

# CMake build type configuration
set( CMAKE_BUILD_TYPE "MinSizeRel" CACHE STRING "" FORCE )
mark_as_advanced( CMAKE_BUILD_TYPE )

# Microchip AVR configuration
set( MICROCHIP_AVR_MCU   "atmega32u4" CACHE STRING "" FORCE )
set( MICROCHIP_AVR_F_CPU "8000000"    CACHE STRING "" FORCE )
mark_as_advanced(
    MICROCHIP_AVR_MCU
    MICROCHIP_AVR_F_CPU
)

# avrdude configuration
set( AVRDUDE_PROGRAM_FLASH "-p" "atmega32u4" "-c" "avr109" "-b" "57600" "-D" CACHE STRING "" FORCE )
set( AVRDUDE_RESET_ENABLED OFF                                               CACHE BOOL   "" FORCE )
set( AVRDUDE_VERIFY_FLASH  "-p" "atmega32u4" "-c" "avr109" "-b" "57600"      CACHE STRING "" FORCE )
mark_as_advanced(
    AVRDUDE_PROGRAM_FLASH
    AVRDUDE_RESET_ENABLED
    AVRDUDE_VERIFY_FLASH
)

include( "${CMAKE_CURRENT_LIST_DIR}/examples/blink/CMakeLists.txt" )
