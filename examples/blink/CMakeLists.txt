# toolchain-avr-gcc
#
# Copyright 2019, 2020 Andrew Countryman <apcountryman@gmail.com>
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

# File: examples/blink/CMakeLists.txt
# Description: toolchain-avr-gcc blink examples CMake rules.

# build the blink examples
option( EXAMPLES_BLINK_ENABLED "examples: build the blink example program" OFF )
if( ${EXAMPLES_BLINK_ENABLED} )
    set(
        EXAMPLES_BLINK_INDICATOR_PORT_LETTER
        ""
        CACHE
        STRING
        "examples: blink example program indicator port letter"
    )
    set(
        EXAMPLES_BLINK_INDICATOR_PIN_NUMBER
        ""
        CACHE
        STRING
        "examples: blink example program indicator pin number"
    )
    set(
        EXAMPLES_BLINK_INDICATOR_BLINK_FREQUENCY_HZ
        "1"
        CACHE
        STRING
        "examples: blink example program indicator blink frequency, in Hz"
    )

    add_executable(
        blink-c
        blink.c
    )
    target_compile_definitions(
        blink-c
        PRIVATE INDICATOR_PORT_LETTER=${EXAMPLES_BLINK_INDICATOR_PORT_LETTER}
        PRIVATE INDICATOR_PIN_NUMBER=${EXAMPLES_BLINK_INDICATOR_PIN_NUMBER}
        PRIVATE INDICATOR_BLINK_FREQUENCY_HZ=${EXAMPLES_BLINK_INDICATOR_BLINK_FREQUENCY_HZ}
    )
    add_avrdude_programming_targets(
        blink-c
        ${AVRDUDE_ALWAYS_RECOVER_FUSES}
        ${AVRDUDE_DISABLE_AUTOMATIC_FLASH_ERASE}
        ${AVRDUDE_DISABLE_AUTOMATIC_VERIFY}
        ${AVRDUDE_DISABLE_FUSE_CHECKS}
        ${AVRDUDE_DISABLE_WRITES}
        ${AVRDUDE_OVERRIDE_SIGNATURE_CHECK}
        BAUD_RATE           ${AVRDUDE_BAUD_RATE}
        BIT_CLOCK           ${AVRDUDE_BIT_CLOCK}
        CONFIGURATION_FILE  ${AVRDUDE_CONFIGURATION_FILE}
        DELAY               ${AVRDUDE_DELAY}
        EXIT_SPECIFICATION  ${AVRDUDE_EXIT_SPECIFICATION}
        EXTENDED_PARAMETERS ${AVRDUDE_EXTENDED_PARAMETERS}
        PART                ${AVRDUDE_PART}
        PORT                ${AVRDUDE_PORT}
        PROGRAMMER          ${AVRDUDE_PROGRAMMER}
        VERBOSITY           ${AVRDUDE_VERBOSITY}

    )

    add_executable(
        blink-c++
        blink.cc
    )
    target_compile_definitions(
        blink-c++
        PRIVATE INDICATOR_PORT_LETTER=${EXAMPLES_BLINK_INDICATOR_PORT_LETTER}
        PRIVATE INDICATOR_PIN_NUMBER=${EXAMPLES_BLINK_INDICATOR_PIN_NUMBER}
        PRIVATE INDICATOR_BLINK_FREQUENCY_HZ=${EXAMPLES_BLINK_INDICATOR_BLINK_FREQUENCY_HZ}
    )
    add_avrdude_programming_targets(
        blink-c++
        ${AVRDUDE_ALWAYS_RECOVER_FUSES}
        ${AVRDUDE_DISABLE_AUTOMATIC_FLASH_ERASE}
        ${AVRDUDE_DISABLE_AUTOMATIC_VERIFY}
        ${AVRDUDE_DISABLE_FUSE_CHECKS}
        ${AVRDUDE_DISABLE_WRITES}
        ${AVRDUDE_OVERRIDE_SIGNATURE_CHECK}
        BAUD_RATE           ${AVRDUDE_BAUD_RATE}
        BIT_CLOCK           ${AVRDUDE_BIT_CLOCK}
        CONFIGURATION_FILE  ${AVRDUDE_CONFIGURATION_FILE}
        DELAY               ${AVRDUDE_DELAY}
        EXIT_SPECIFICATION  ${AVRDUDE_EXIT_SPECIFICATION}
        EXTENDED_PARAMETERS ${AVRDUDE_EXTENDED_PARAMETERS}
        PART                ${AVRDUDE_PART}
        PORT                ${AVRDUDE_PORT}
        PROGRAMMER          ${AVRDUDE_PROGRAMMER}
        VERBOSITY           ${AVRDUDE_VERBOSITY}

    )
endif( ${EXAMPLES_BLINK_ENABLED} )
