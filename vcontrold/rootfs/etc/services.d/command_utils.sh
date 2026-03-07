#!/usr/bin/with-contenv bashio

load_vcontrold_commands_array() {
    local commands_raw=${1-}
    local -n output_array=$2

    output_array=()
    mapfile -t output_array <<< "${commands_raw}"

    if (( ${#output_array[@]} == 1 )) && [[ "${output_array[0]}" == *'|'* ]]; then
        IFS='|' read -r -a output_array <<< "${output_array[0]}"
    fi
}
