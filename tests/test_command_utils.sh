#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

source "${repo_root}/tests/lib/assert.sh"
source "${repo_root}/vcontrold/rootfs/etc/services.d/command_utils.sh"

declare -a commands_array=()

load_vcontrold_commands_array $'getTempA:FLOAT\ngetTempWWist:FLOAT\ngetTempWWsoll:FLOAT' commands_array
assert_eq "3" "${#commands_array[@]}" "multiline command count"
assert_eq "getTempA:FLOAT" "${commands_array[0]}" "multiline first command"
assert_eq "getTempWWist:FLOAT" "${commands_array[1]}" "multiline second command"
assert_eq "getTempWWsoll:FLOAT" "${commands_array[2]}" "multiline third command"

load_vcontrold_commands_array 'getTempA:FLOAT|getTempWWist:FLOAT|getTempWWsoll:FLOAT' commands_array
assert_eq "3" "${#commands_array[@]}" "pipe-delimited command count"
assert_eq "getTempA:FLOAT" "${commands_array[0]}" "pipe-delimited first command"
assert_eq "getTempWWist:FLOAT" "${commands_array[1]}" "pipe-delimited second command"
assert_eq "getTempWWsoll:FLOAT" "${commands_array[2]}" "pipe-delimited third command"

printf 'PASS: %s\n' "$(basename "$0")"
