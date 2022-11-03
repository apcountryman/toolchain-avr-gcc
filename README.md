# toolchain-avr-gcc
[![CI](https://github.com/apcountryman/toolchain-avr-gcc/actions/workflows/ci.yml/badge.svg)](https://github.com/apcountryman/toolchain-avr-gcc/actions/workflows/ci.yml)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.0-4baaaa.svg)](CODE_OF_CONDUCT.md)

`toolchain-avr-gcc` is a CMake toolchain for cross compiling for the Microchip AVR family
of microcontrollers using avr-gcc.
In addition to configuring CMake for cross compiling with avr-gcc, the toolchain provides
optional avrdude utilities.

## Obtaining the Source Code
HTTPS:
```shell
git clone https://github.com/apcountryman/toolchain-avr-gcc.git
```
SSH:
```shell
git clone git@github.com:apcountryman/toolchain-avr-gcc.git
```

## Usage (Dependency)
To use this toolchain, simply set `CMAKE_TOOLCHAIN_FILE` to the path to this repository's
`toolchain.cmake` file when initializing CMake.

To use the avrdude utilities, add the path to this repository to the project's
`CMAKE_MODULE_PATH`, and include `avrdude-utilities.cmake`.
The avrdude utilities include the following functions:
- `add_avrdude_target()`
- `add_avrdude_programming_targets()`

Documentation for the usage of the avrdude utilities [can be found in the
`avrdude-utilities.cmake` file in this repository](avrdude-utilities.cmake).
Usage examples [can be found in the `examples` directory in this repository](examples).

### Finding Tools
This toolchain expects to find `avr-gcc`, `avr-g++`, associated binary utilities, and
`avrdude` in the path(s) searched by CMake's `find_program()` command.
`avrdude` is only required if `avrdude-utilities.cmake` is included.
If the toolchain fails to locate tools, consult the documentation for CMake's
`find_program()` command.

## Usage (Development)
This repository's Git `pre-commit` hook script is the simplest way to configure, build,
and test this project during development.
See the `pre-commit` script's help text for usage details.
```shell
./git/hooks/pre-commit --help
```

Additional checks, such as static analysis, are performed by this project's GitHub Actions
CI workflow.

## Versioning
Post version 0.3.0, `toolchain-avr-gcc` will follow the [Abseil Live at Head
philosophy](https://abseil.io/about/philosophy).

## Workflow
`toolchain-avr-gcc` uses the [GitHub flow](https://guides.github.com/introduction/flow/)
workflow.

## Git Hooks
To install this repository's Git hooks, run the `install` script located in the
`git/hooks` directory.
See the script's help text for usage details.
```
$ ./git/hooks/install --help
```

## Code of Conduct
`toolchain-avr-gcc` has adopted the Contributor Covenant 2.0 code of conduct.
For more information, [see the `CODE_OF_CONDUCT.md` file in this
repository](CODE_OF_CONDUCT.md).

## Contributing
If you are interested in contributing to `toolchain-avr-gcc`, please [read the
`CONTRIBUTING.md` file in this repository](CONTRIBUTING.md).

## Authors
- Andrew Countryman

## License
`toolchain-avr-gcc` is licensed under the Apache License, Version 2.0.
For more information, [see the LICENSE file in this repository](LICENSE).
