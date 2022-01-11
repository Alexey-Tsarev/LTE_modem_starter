#!/bin/bash

log() {
    if [ -n "$1" ]; then
        logger -t udev "$1"
    fi
}

#write_debug() {
#    timestamp="$(date "+%s.%N")"
#    tmp_file="/root/script/LTE-modem/tmp_${timestamp}.txt"
#
#    {
#        date
#        echo "${config_value_file}"
#        echo "${config_value}"
#        env
#    } > "${tmp_file}"
#}

DEVICE_PATH_IN_FILE="${DEVICE_PATH_IN_FILE:=/var/tmp/LTE-modem-device-path.txt}"

#write_debug

if [ -z "$1" ]; then
    echo "First parameter - device id (e.g. 413c:81d7) is not provided"
    exit 1
fi

cur_dir="$(dirname "$0")"
. "${cur_dir}/config.cfg"

if [ "$1" = "${ID_VENDOR_ID}:${ID_MODEL_ID}" ] && [ "${ACTION}" = "add" ] && [ "${DEVTYPE}" = "usb_device" ]; then
    device_path="$(findmnt -t sysfs --output=target -n)${DEVPATH}"
    config_value_file="${device_path}/bConfigurationValue"
    config_value="$(cat "${config_value_file}")"
    log "Device: '${ID_SERIAL}', path: '${config_value_file}', current config value: '${config_value}'"

    write_device_path_file_flag=1

    if [ -f "${DEVICE_PATH_IN_FILE}" ]; then
        device_path_from_file="$(cat "${DEVICE_PATH_IN_FILE}")"

        if [ "${device_path_from_file}" = "${device_path}" ]; then
            write_device_path_file_flag=0
        fi
    fi

    if [ "${write_device_path_file_flag}" -eq "1" ]; then
        log "Write to file: '${DEVICE_PATH_IN_FILE}'"
        echo "${device_path}" > "${DEVICE_PATH_IN_FILE}"
    fi

    log "Start service: 'LTE-modem-starter'"
    systemctl start LTE-modem-starter
#    write_debug
fi
