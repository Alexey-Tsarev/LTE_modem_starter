#!/bin/bash

# Based on https://github.com/openwrt/openwrt/blob/master/package/network/utils/uqmi/files/lib/netifd/proto/qmi.sh

proto_qmi_setup() {
	local interface="$1"

	[ "$timeout" = "" ] && timeout="10"

	[ "$metric" = "" ] && metric="0"

	[ -n "$ctl_device" ] && device=$ctl_device

	[ -n "$device" ] || {
		echo "No control device specified"
		proto_notify_error "$interface" NO_DEVICE
		proto_set_available "$interface" 0
		return 1
	}

	[ -n "$delay" ] && sleep "$delay"

	device="$(readlink -f $device)"
	[ -c "$device" ] || {
		echo "The specified control device does not exist"
# 		proto_notify_error "$interface" NO_DEVICE
# 		proto_set_available "$interface" 0
		return 1
	}

	devname="$(basename "$device")"
	devpath="$(readlink -f /sys/class/usbmisc/$devname/device/)"
	ifname="$( ls "$devpath"/net )"
	[ -n "$ifname" ] || {
		echo "The interface could not be found."
# 		proto_notify_error "$interface" NO_IFACE
# 		proto_set_available "$interface" 0
		return 1
	}

	[ -n "$mtu" ] && {
		echo "Setting MTU to $mtu"
		/sbin/ip link set dev $ifname mtu $mtu
	}

	echo "Stopping qmi-network at '${device}'"
	qmi-network "${device}" stop

	echo "Waiting for SIM initialization"
	local uninitialized_timeout=0
# 	while qmicli -s -d "$device" --get-pin-status | grep '"UIM uninitialized"' > /dev/null; do
	while qmicli -d "${device}" --uim-get-card-status | grep '"UIM uninitialized"' > /dev/null; do
		[ -e "$device" ] || return 1
		if [ "$uninitialized_timeout" -lt "$timeout" -o "$timeout" = "0" ]; then
			let uninitialized_timeout++
			sleep 1;
		else
			echo "SIM not initialized"
			proto_notify_error "$interface" SIM_NOT_INITIALIZED
			proto_block_restart "$interface"
			return 1
		fi
	done

	# Cleanup current state if any
#	uqmi -s -d "$device" --stop-network 0xffffffff --autoconnect > /dev/null 2>&1
# 	qmicli -d "${device}" --wds-stop-network=disable-autoconnect
	qmicli -d "${device}" --wds-start-network= --client-no-release-cid

	# Go online
	#uqmi -s -d "$device" --set-device-operating-mode online > /dev/null 2>&1
	qmicli -d "${device}" --dms-set-operating-mode='online'

	# Set IP format
	ip link set "${ifname}" down
	echo Y > /sys/class/net/$ifname/qmi/raw_ip
	ip link set "${ifname}" up

	echo "Starting qmi-network at '${device}'"
# 	qmicli --device=/dev/cdc-wdm0 --device-open-proxy --wds-start-network="ip-type=4,apn=${apn}" --client-no-release-cid
# 	qmicli --device=/dev/cdc-wdm0 --device-open-proxy --wds-start-network="${apn}" --client-no-release-cid
	qmi-network "${device}" start
	qmicli --device=/dev/cdc-wdm0 --wds-get-current-settings

	echo "Waiting for network registration"
	sleep 1
	local registration_timeout=0
	local registration_state=""
	while true; do
#		registration_state=$(uqmi -s -d "$device" --get-serving-system 2>/dev/null | jsonfilter -e "@.registration" 2>/dev/null)
		registration_state=$(qmicli -d "${device}" --nas-get-serving-system | grep "Registration state" | sed "s/.*'\(.*\)'/\1/")
		echo "Registration state: '${registration_state}'"

		[ "$registration_state" = "registered" ] && break

		if [ "$registration_state" = "searching" ] || [ "$registration_state" = "not_registered" ]; then
			if [ "$registration_timeout" -lt "$timeout" ] || [ "$timeout" = "0" ]; then
				[ "$registration_state" = "searching" ] || {
					echo "Device stopped network registration. Restart network registration"
#					uqmi -s -d "$device" --network-register > /dev/null 2>&1
					echo "Starting qmi-network at '${device}'"
					qmi-network "${device}" start
				}
				let registration_timeout++
				sleep 1
				continue
			fi
			echo "Network registration failed, registration timeout reached"
		else
			# registration_state is 'registration_denied' or 'unknown' or ''
			echo "Network registration failed (reason: '$registration_state')"
		fi

# 		proto_notify_error "$interface" NETWORK_REGISTRATION_FAILED
# 		proto_block_restart "$interface"
		return 1
	done

# 	[ -n "$modes" ] && uqmi -s -d "$device" --set-network-modes "$modes" > /dev/null 2>&1

	echo "Starting network $interface"
	udhcpc -n -q -f -i "${interface}"
}

go_to_qmi() {
    if [ -n "$1" ]; then
        if [ -f "$1" ]; then
            echo "Setting device to use QMI: '$1'"
            echo -1 2>/dev/null > "$1"
            echo  1 2>/dev/null > "$1"
        else
            echo "Error: '$1' is not found"
        fi
    else
        echo "Error: first parameter - device 'bConfigurationValue' file is not provided"
        exit 1
    fi
}


cur_dir="$(dirname "$0")"
. "${cur_dir}/config.cfg"

attempt=1
while true; do
    echo "Attempt: ${attempt}"

    if [ -f "${DEVICE_PATH_IN_FILE}" ]; then
        device_file="$(cat "${DEVICE_PATH_IN_FILE}")"
        device_config_value="${device_file}/bConfigurationValue"
        config_mode="$(cat "${device_config_value}")"

        if [ -n "${config_mode}" ]; then
            echo "Device: '${device_config_value}', config mode: '${config_mode}'"

            if [ "${config_mode}" -ne "1" ]; then
                go_to_qmi "${device_config_value}"
            fi

            if [ -n "${device_file}" ]; then
                echo "Finding device"
                device_only="$(find ${device_file}/*/usbmisc/* -maxdepth 0 -type d | grep -v hiddev | awk -F / '{print $NF}')"

                if [ -n "${device_only}" ]; then
                    device="/dev/${device_only}"
                    echo "Device: '${device}'"

                    echo "Getting interface"
                    ifname="$(qmicli -d "${device}" --get-wwan-iface --device-open-sync)"

                    if [ -n "${ifname}" ]; then
                        echo "Interface: '${ifname}'"

                        proto_qmi_setup "${ifname}"
                        if [ "$?" -eq 0 ]; then
                            echo "Done!"
                            break
                        fi
                    else
                        echo "Error: 'ifname' is not found"
                    fi
                else
                    echo "Error: 'device_only' is not found"
                fi
            else
                echo "Error: 'device_file' is not found"
            fi
        else
            echo "Error: 'config_mode' is not found"
        fi
    else
        echo "Error: '${DEVICE_PATH_IN_FILE}' is not found"
    fi

    if [ -n "${config_mode}" ]; then
        go_to_qmi "${device_config_value}"
    fi

    let attempt++
    echo "Retrying"
    echo

    sleep 1
done
