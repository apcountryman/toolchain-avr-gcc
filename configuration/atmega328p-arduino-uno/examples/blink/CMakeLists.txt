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

# File: configuration/atmega328p-arduino-uno/examples/blink/CMakeLists.txt
# Description: ATmega328/P Arduino Uno toolchain-avr-gcc blink examples configuration.

set( EXAMPLES_BLINK_ENABLED               ON  CACHE BOOL   "" FORCE )
set( EXAMPLES_BLINK_INDICATOR_PORT_LETTER "B" CACHE STRING "" FORCE )
set( EXAMPLES_BLINK_INDICATOR_PIN_NUMBER  "5" CACHE STRING "" FORCE )
mark_as_advanced(
    EXAMPLES_BLINK_ENABLED
    EXAMPLES_BLINK_INDICATOR_PORT_LETTER
    EXAMPLES_BLINK_INDICATOR_PIN_NUMBER
)
