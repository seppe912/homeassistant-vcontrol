#!/usr/bin/with-contenv bashio

declare -ag MQTT_AUTH_ARGS=()

MQTT_TOPIC=$(bashio::config 'mqtt_topic')
export MQTT_TOPIC

if bashio::config.has_value 'mqtt_host'; then
    MQTT_HOST=$(bashio::config 'mqtt_host')

    if bashio::config.has_value 'mqtt_port'; then
        MQTT_PORT=$(bashio::config 'mqtt_port')
    else
        MQTT_PORT="1883"
        bashio::log.info "mqtt_port not set in configuration. Defaulting to '1883'."
    fi

    MQTT_USER=""
    MQTT_PASSWORD=""

    if bashio::config.has_value 'mqtt_user'; then
        MQTT_USER=$(bashio::config 'mqtt_user')
    fi

    if bashio::config.has_value 'mqtt_password'; then
        MQTT_PASSWORD=$(bashio::config 'mqtt_password')
    fi

    bashio::log.info "Using configured MQTT Host: ${MQTT_HOST}:${MQTT_PORT}"
elif bashio::services.available "mqtt"; then
    MQTT_HOST=$(bashio::services mqtt "host")
    MQTT_PORT=$(bashio::services mqtt "port")
    MQTT_USER=$(bashio::services mqtt "username")
    MQTT_PASSWORD=$(bashio::services mqtt "password")
    bashio::log.info "Using internal MQTT Host: ${MQTT_HOST}:${MQTT_PORT}"
else
    bashio::exit.nok "No MQTT broker configured and no internal MQTT service available"
fi

export MQTT_HOST MQTT_PORT MQTT_USER MQTT_PASSWORD

if [[ -n "${MQTT_USER:-}" ]]; then
    MQTT_AUTH_ARGS+=(-u "$MQTT_USER")

    if [[ -n "${MQTT_PASSWORD:-}" ]]; then
        MQTT_AUTH_ARGS+=(-P "$MQTT_PASSWORD")
    fi
elif [[ -n "${MQTT_PASSWORD:-}" ]]; then
    bashio::log.warning "MQTT password is set without a username. Ignoring the password."
fi
