#!/bin/sh

log() {
    if [ -n "$1" ]; then
        logger -t udev "$1"
    fi
}


if [ -z "$1" ]; then
    echo "First parameter 'DEVICE_PRODUCT' is not provided"
    exit 1
fi

cur_dir="$(dirname "$0")"
. "${cur_dir}/config.cfg"
DEVICE_PRODUCT="$1"

if [ "${PRODUCT}" = "${DEVICE_PRODUCT}" ] && [ "${ACTION}" = "add" ] && [ "${ID_BUS}" = "usb" ]; then
    device_path="/sys${DEVPATH}"
    config_mode="$(cat "${device_path}/bConfigurationValue")"
    log "Device: '${ID_SERIAL}', path: '${device_path}', config mode: '${config_mode}'"

    log "Create file: '${DEVICE_PATH_IN_FILE}'"
    echo "${device_path}" > "${DEVICE_PATH_IN_FILE}"

    if [ -f "${DEVICE_PATH_IN_FILE}" ]; then
        log "Run service: 'LTE-modem-starter'"
        systemctl start LTE-modem-starter
    else
        log "File not found: '${DEVICE_PATH_IN_FILE}'"
    fi
fi
