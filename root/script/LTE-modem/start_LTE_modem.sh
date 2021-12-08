#!/bin/bash

modem_setup() {
    echo "Stop ${MODE}-network at '${device}'"
    "${MODE}-network" "${device}" stop

    echo "Wait for SIM initialization"

    setup_attempt=0
    while true; do
        if [ "${MODE}" = "qmi" ]; then
            status_out="$(qmicli -d "${device}" --uim-get-card-status)"
            echo "${status_out}" | grep -q "Card state: 'present'"
            status_ec="$?"
        elif [ "${MODE}" = "mbim" ]; then
            status_out="$(mbimcli -d "${device}" --query-subscriber-ready-status)"
            echo "${status_out}" | grep -q "Ready state: 'initialized'"
            status_ec="$?"
        fi

        if [ "${status_ec}" = 0 ]; then
            break
        else
            echo "Init error. Output:"
            echo "${status_out}"

            if [ "${setup_attempt}" -lt "${RETRY_ATTEMPTS}" ]; then
                ((setup_attempt++))
                echo "Retry"
                sleep 1
            else
                echo "Error: SIM not initialized, timeout reached"
                return 1
            fi
        fi
    done

    # Cleanup current state if any
    if [ "${MODE}" = "qmi" ]; then
        qmicli -d "${device}" --wds-start-network= --client-no-release-cid
    #elif [ "${MODE}" = "mbim" ]; then
    fi

    # Go online
    if [ "${MODE}" = "qmi" ]; then
        qmicli -d "${device}" --dms-set-operating-mode='online'
    #elif [ "${MODE}" = "mbim" ]; then
    fi

    # Set IP format
    if [ "${MODE}" = "qmi" ]; then
        ip link set "${interface}" down

        qmi_raw_ip_file="/sys/class/net/${interface}/qmi/raw_ip"
        if [ -f "${qmi_raw_ip_file}" ]; then
            echo "Y" > "${qmi_raw_ip_file}"
        else
            echo "File not found: '${qmi_raw_ip_file}'"
        fi

        ip link set "${interface}" up
    #elif [ "${MODE}" = "mbim" ]; then
    fi

    echo "Start ${MODE}-network at '${device}'"
    "${MODE}-network" "${device}" start

    echo "Wait for network registration"

    register_attempt=0
    while true; do
        if [ "${MODE}" = "qmi" ]; then
            register_out="$(qmicli -d "${device}" --nas-get-serving-system)"
            register_part="$(echo "${register_out}" | grep "Registration state" | sed "s/.*'\(.*\)'/\1/")"
            register_need="registered"
        elif [ "${MODE}" = "mbim" ]; then
            register_out="$(mbimcli -d "${device}" --query-connection-state --no-open=$(date '+%s') --no-close)"
            register_part="$(echo "${register_out}" | grep "Activation state" | sed "s/.*'\(.*\)'/\1/")"
            register_need="activated"
        fi

        if [ "${register_part}" = "${register_need}" ]; then
            break
        else
            echo "Network registration failed. Output:"
            echo "${register_out}"

            if [ "${register_attempt}" -lt "${RETRY_ATTEMPTS}" ]; then
                ((register_attempt++))
                echo "Retry"
                sleep 1
            else
                echo "Network registration failed, timeout reached"
                return 2
            fi
        fi
    done

    if [ "${MODE}" = "qmi" ]; then
        qmicli -d "${device}" --wds-get-current-settings
    elif [ "${MODE}" = "mbim" ]; then
        mbimcli -d "${device}" --query-home-provider --no-open="$(date '+%s')" --no-close
    fi

    echo "Start DHCP client at interface: '${interface}'"

    if udhcpc -n -q -f -i "${interface}"; then
        ip addr show "${interface}"
    else
        echo "DHCP client failed"
        return 3
    fi
}

go_to_mode() {
    if [ -n "$1" ]; then
        if [ -f "$1" ]; then
            echo "Set device: '$1', config value: '${CONFIG_VALUE}'"
            echo -1 2> /dev/null > "$1"
            echo "${CONFIG_VALUE}" 2> /dev/null > "$1"

            sleep 1 # need to wait the wwan0 interface renaming
        else
            echo "Error: '$1' is not found"
        fi
    else
        echo "Error: first parameter - device 'bConfigurationValue' file is not provided"
        exit 4
    fi
}

cur_dir="$(dirname "$0")"
. "${cur_dir}/config.cfg"

if [ -z "${DEVICE_PATH_IN_FILE}" ]; then
    echo "'DEVICE_PATH_IN_FILE' is not set"
    exit 1
fi

if [ -z "${MODE}" ]; then
    echo "'MODE' is not set. Valid values are: qmi, mbim"
    exit 2
fi

if [ -z "${RETRY_ATTEMPTS}" ]; then
    echo "'RETRY_ATTEMPTS' is not set"
    exit 3
fi

attempt=1
while true; do
    echo "Attempt: ${attempt}"

    if [ -f "${DEVICE_PATH_IN_FILE}" ]; then
        device_file="$(cat "${DEVICE_PATH_IN_FILE}")"
        device_config_value="${device_file}/bConfigurationValue"
        config_value="$(cat "${device_config_value}")"

        if [ -n "${config_value}" ]; then
            if [ -n "${CONFIG_VALUE}" ]; then
                echo "Device: '${device_config_value}', current config value: '${config_value}'"

                if [ "${config_value}" = "${CONFIG_VALUE}" ] && [ "${attempt}" -eq "1" ]; then
                    echo "Device config value is already set"
                else
                    go_to_mode "${device_config_value}"
                fi
            fi

            if [ -n "${device_file}" ]; then
                echo "Find device"
                device_only="$(find "${device_file}"/*/usbmisc/* -maxdepth 0 -type d | grep -v hiddev | awk -F / '{print $NF}')"

                if [ -n "${device_only}" ]; then
                    device="/dev/${device_only}"
                    echo "Device: '${device}'"

                    echo "Get interface"
                    interface="$(find "${device_file}"/*/net/* -maxdepth 0 -type d | grep -v hiddev | awk -F / '{print $NF}')"

                    if [ -n "${interface}" ]; then
                        echo "Interface: '${interface}'"

                        if modem_setup; then
                            for at in "${STATUS_AT_CMD[@]}"; do
                                echo "${at}" | socat - /dev/ttyUSB0,echo=0,raw,crlf
                            done

                            break
                        fi
                    else
                        echo "Error: 'interface' is not found"
                    fi
                else
                    echo "Error: 'device_only' is not found"
                fi
            else
                echo "Error: 'device_file' is not found"
            fi
        else
            echo "Error: 'config_value' is not found"
        fi
    else
        echo "Error: '${DEVICE_PATH_IN_FILE}' is not found"
    fi

    ((attempt++))
    echo "Retry"
    echo

    sleep 1
done
