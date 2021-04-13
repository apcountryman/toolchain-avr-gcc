#!/usr/bin/env python

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

import argparse
import serial


def reset(port):
    serial_port = serial.Serial(port=port, baudrate=1200)
    serial_port.close()


def main():
    argument_parser = argparse.ArgumentParser(
        description='Reset an AVR by opening the port it is connected to at 1200 bits/second, and then closing the port.')
    argument_parser.add_argument(
        'port', help='The port the AVR is connected to.')
    arguments = argument_parser.parse_args()

    reset(arguments.port)


if __name__ == '__main__':
    main()
