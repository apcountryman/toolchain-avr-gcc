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

# Description: CI static analysis script.

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
    local analyzer

    printf "%b" \
        "NAME\n" \
        "    $mnemonic - Ensure no static analysis errors are present.\n" \
        "SYNOPSIS\n" \
        "    $mnemonic --help\n" \
        "    $mnemonic --version\n" \
        "    $mnemonic --analyzer <analyzer>\n" \
        "OPTIONS\n" \
        "    --analyzer <analyzer>\n" \
        "        Specify the analyzer to run. The following analyzers are supported:\n" \
        ""

    for analyzer in "${analyzers[@]}"; do
        printf "%b" \
            "            $analyzer\n" \
            ""
    done

    printf "%b" \
        "    --help\n" \
        "        Display this help text.\n" \
        "    --version\n" \
        "        Display the version of this script.\n" \
        "EXAMPLES\n" \
        "    $mnemonic --help\n" \
        "    $mnemonic --version\n" \
        ""

    for analyzer in "${analyzers[@]}"; do
        printf "%b" \
            "    $mnemonic --analyzer $analyzer\n" \
            ""
    done
}

function display_version()
{
    echo "$mnemonic, version $version"
}

function value_is_in_array()
{
    local -r target_value="$1"; shift
    local -r array=( "$@" )

    local value
    for value in "${array[@]}"; do
        if [[ "$target_value" == "$value" ]]; then
            return 0;
        fi
    done

    return 1
}

function run_shellcheck()
{
    local scripts; mapfile -t scripts < <( git -C "$repository" ls-files '*.sh' | xargs -r -d '\n' -I '{}' find "$repository/{}" ); readonly scripts

    if ! shellcheck "${scripts[@]}"; then
        abort
    fi
}

function ensure_no_static_analysis_errors_are_present()
{
    "run_$analyzer"
}

function main()
{
    local -r script=$( readlink -f "$0" )
    local -r mnemonic=$( basename "$script" )

    validate_script

    local -r repository=$( readlink -f "$( dirname "$script" )/.." )
    local -r version=$( git -C "$repository" describe --match=none --always --dirty --broken )

    local -r analyzers=(
        shellcheck
    )

    while [[ "$#" -gt 0 ]]; do
        local argument="$1"; shift

        case "$argument" in
            --analyzer)
                if [[ -n "$analyzer" ]]; then
                    abort "analyzer already specified"
                fi

                if [[ "$#" -le 0 ]]; then
                    abort "analyzer not specified"
                fi

                local -r analyzer="$1"; shift

                if ! value_is_in_array "$analyzer" "${analyzers[@]}"; then
                    abort "'$analyzer' is not a supported analyzer"
                fi
                ;;
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

    if [[ -z "$analyzer" ]]; then
        abort "'--analyzer' must be specified"
    fi

    ensure_no_static_analysis_errors_are_present
}

main "$@"
