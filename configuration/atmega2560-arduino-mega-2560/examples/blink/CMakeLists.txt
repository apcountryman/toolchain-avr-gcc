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

# File: configuration/atmega2560-arduino-mega-2560/examples/blink/CMakeLists.txt
# Description: ATmega2560 Arduino Mega 2560 toolchain-avr-gcc blink examples
#       configuration.

set( EXAMPLES_BLINK_ENABLED               ON  CACHE INTERNAL "" )
set( EXAMPLES_BLINK_INDICATOR_PORT_LETTER "B" CACHE INTERNAL "" )
set( EXAMPLES_BLINK_INDICATOR_PIN_NUMBER  "7" CACHE INTERNAL "" )
