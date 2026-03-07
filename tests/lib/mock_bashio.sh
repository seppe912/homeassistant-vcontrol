#!/usr/bin/env bash

bashio::config() {
    local key=$1
    local var_name="BASHIO_CONFIG_${key}"
    printf '%s' "${!var_name-}"
}

bashio::config.has_value() {
    local key=$1
    local var_name="BASHIO_CONFIG_${key}"

    [[ -n "${!var_name-}" ]]
}

bashio::config.true() {
    local value
    value=$(bashio::config "$1")

    case "${value}" in
        true|True|TRUE|yes|Yes|YES|on|On|ON|1)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

bashio::services.available() {
    local service_name=$1
    local var_name="BASHIO_SERVICE_AVAILABLE_${service_name}"

    [[ "${!var_name-}" == "true" ]]
}

bashio::services() {
    local service_name=$1
    local field_name=$2
    local var_name="BASHIO_SERVICE_${service_name}_${field_name}"
    printf '%s' "${!var_name-}"
}

bashio::log.info() {
    printf 'INFO: %s\n' "$*"
}

bashio::log.warning() {
    printf 'WARN: %s\n' "$*"
}

bashio::log.error() {
    printf 'ERROR: %s\n' "$*" >&2
}

bashio::exit.nok() {
    bashio::log.error "$*"
    exit 1
}
