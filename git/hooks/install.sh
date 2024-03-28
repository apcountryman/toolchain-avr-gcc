#!/usr/bin/env bash

# toolchain-avr-gcc
#
# Copyright 2019-2024, Andrew Countryman <apcountryman@gmail.com> and the
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

# Description: Git hooks install script.

function error()
{
    local -r message="$1"

    ( >&2 echo "$mnemonic: $message" )
}

function abort()
{
    if [[ "$#" -gt 0 ]]; then
        local -r message="$1"

        error "$message, aborting"
    fi

    exit 1
}

function validate_script()
{
    if ! shellcheck "$script"; then
        abort
    fi
}

function display_help_text()
{
    printf "%b" \
        "NAME\n" \
        "    $mnemonic - Install Git hooks.\n" \
        "SYNOPSIS\n" \
        "    $mnemonic --help\n" \
        "    $mnemonic --version\n" \
        "    $mnemonic\n" \
        "OPTIONS\n" \
        "    --help\n" \
        "        Display this help text.\n" \
        "    --version\n" \
        "        Display the version of this script.\n" \
        "EXAMPLES\n" \
        "    $mnemonic --help\n" \
        "    $mnemonic --version\n" \
        "    $mnemonic\n" \
        ""
}

function display_version()
{
    echo "$mnemonic, version $version"
}

function install_git_hooks()
{
    local hook_scripts; mapfile -t hook_scripts < <( git -C "$repository" ls-files 'git/hooks/' ':!:git/hooks/install.sh' | xargs -r -d '\n' -I '{}' find "$repository/{}" ); readonly hook_scripts

    local hook_script
    for hook_script in "${hook_scripts[@]}"; do
        local hook; hook=$( basename "$hook_script" | cut -f 1 -d '.' )

        rm -f "$repository/.git/hooks/$hook"

        if ! ln -s "$hook_script" "$repository/.git/hooks/$hook"; then
            abort "'$hook' installation failure"
        fi
    done
}

function main()
{
    local -r script=$( readlink -f "$0" )
    local -r mnemonic=$( basename "$script" )

    validate_script

    local -r repository=$( readlink -f "$( dirname "$script" )/../.." )
    local -r version=$( git -C "$repository" describe --match=none --always --dirty --broken )

    while [[ "$#" -gt 0 ]]; do
        local argument="$1"; shift

        case "$argument" in
            --help)
                display_help_text
                exit
                ;;
            --version)
                display_version
                exit
                ;;
            --*)
                ;&
            -*)
                abort "'$argument' is not a supported option"
                ;;
            *)
                abort "'$argument' is not a valid argument"
                ;;
        esac
    done

    install_git_hooks
}

main "$@"
