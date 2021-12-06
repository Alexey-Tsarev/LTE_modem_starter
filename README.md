# LTE modem starter
This repository is a pack of scripts to run LTE modem in Linux.

I use:
- DW5821e
- ROCK Pi E D4W1 https://wiki.radxa.com/RockpiE/hardware/models
- Armbian Bullseye https://www.armbian.com/rockpie/

## Install
```
# apt install wget libqmi-utils
```

Download the folowing archive to a temporary directory:
```
$ wget https://codeload.github.com/Alexey-Tsarev/LTE_modem_starter/zip/refs/heads/master -O LTE_modem_starter.zip
```

Unzip it:
```
$ unzip LTE_modem_starter.zip
```

Place all files from `etc` and `root` directories to your system as:
```
LTE_modem_starter-master/etc  -> /etc
LTE_modem_starter-master/root -> /root
```

Reattach your LTE modem (when it connected to a USB port) or reboot your machine and look at logs:
```
tail -n +1 -f /var/log/syslog
```

## Logs example
```
# cat /var/log/syslog
...
Dec  7 00:55:10 rockpi-e udev: Device: 'Dell_Inc._DW5821e_Snapdragon_X20_LTE_0123456789ABCDEF', path: '/sys/devices/platform/ff600000.usb/xhci-hcd.0.auto/usb5/5-1', config mode: '1'
Dec  7 00:55:10 rockpi-e udev: Create file: '/var/tmp/LTE-modem-device-path.txt'
Dec  7 00:55:10 rockpi-e udev: Run service: 'LTE-modem-starter'
...
Dec  7 00:55:11 rockpi-e kernel: [  132.062019] qmi_wwan 5-1:1.0 wwanlte: renamed from wwan0
...
```
```
# journalctl -b --no-pager -u LTE-modem-starter
-- Journal begins at Tue 2021-12-07 00:22:59 +04, ends at Tue 2021-12-07 01:10:01 +04. --
Dec 07 00:55:09 rockpi-e systemd[1]: Started Run LTE modem in QMI mode.
Dec 07 00:55:09 rockpi-e start_LTE_QMI.sh[1305]: Attempt: 1
Dec 07 00:55:09 rockpi-e start_LTE_QMI.sh[1305]: Device: '/sys/devices/platform/ff600000.usb/xhci-hcd.0.auto/usb5/5-1/bConfigurationValue', config mode: '2'
Dec 07 00:55:09 rockpi-e start_LTE_QMI.sh[1305]: Setting device to use QMI: '/sys/devices/platform/ff600000.usb/xhci-hcd.0.auto/usb5/5-1/bConfigurationValue'
Dec 07 00:55:09 rockpi-e start_LTE_QMI.sh[1305]: Finding device
Dec 07 00:55:09 rockpi-e start_LTE_QMI.sh[1305]: Device: '/dev/cdc-wdm0'
Dec 07 00:55:09 rockpi-e start_LTE_QMI.sh[1305]: Getting interface
Dec 07 00:55:12 rockpi-e start_LTE_QMI.sh[1305]: Interface: 'wwanlte'
Dec 07 00:55:12 rockpi-e start_LTE_QMI.sh[1305]: Stopping qmi-network at '/dev/cdc-wdm0'
Dec 07 00:55:12 rockpi-e start_LTE_QMI.sh[1688]: Profile at '/etc/qmi-network.conf' not found...
Dec 07 00:55:12 rockpi-e start_LTE_QMI.sh[1688]: Network already stopped
Dec 07 00:55:12 rockpi-e start_LTE_QMI.sh[1688]: Clearing state at /tmp/qmi-network-state-cdc-wdm0...
Dec 07 00:55:12 rockpi-e start_LTE_QMI.sh[1305]: Waiting for SIM initialization
Dec 07 00:55:12 rockpi-e start_LTE_QMI.sh[1695]: [/dev/cdc-wdm0] Network started
Dec 07 00:55:12 rockpi-e start_LTE_QMI.sh[1695]:         Packet data handle: '1654808256'
Dec 07 00:55:12 rockpi-e start_LTE_QMI.sh[1695]: [/dev/cdc-wdm0] Client ID not released:
Dec 07 00:55:12 rockpi-e start_LTE_QMI.sh[1695]:         Service: 'wds'
Dec 07 00:55:12 rockpi-e start_LTE_QMI.sh[1695]:             CID: '18'
Dec 07 00:55:13 rockpi-e start_LTE_QMI.sh[1698]: [/dev/cdc-wdm0] Operating mode set successfully
Dec 07 00:55:13 rockpi-e start_LTE_QMI.sh[1305]: Starting qmi-network at '/dev/cdc-wdm0'
Dec 07 00:55:13 rockpi-e start_LTE_QMI.sh[1703]: Profile at '/etc/qmi-network.conf' not found...
Dec 07 00:55:13 rockpi-e start_LTE_QMI.sh[1703]: Checking data format with 'qmicli -d /dev/cdc-wdm0 --wda-get-data-format '...
Dec 07 00:55:13 rockpi-e start_LTE_QMI.sh[1703]: Device link layer protocol retrieved: raw-ip
Dec 07 00:55:13 rockpi-e start_LTE_QMI.sh[1703]: Getting expected data format with 'qmicli -d /dev/cdc-wdm0 --get-expected-data-format'...
Dec 07 00:55:13 rockpi-e start_LTE_QMI.sh[1703]: Expected link layer protocol retrieved: raw-ip
Dec 07 00:55:13 rockpi-e start_LTE_QMI.sh[1703]: Device and kernel link layer protocol match: raw-ip
Dec 07 00:55:13 rockpi-e start_LTE_QMI.sh[1703]: Starting network with 'qmicli -d /dev/cdc-wdm0 --wds-start-network=  --client-no-release-cid '...
Dec 07 00:55:13 rockpi-e start_LTE_QMI.sh[1703]: Saving state at /tmp/qmi-network-state-cdc-wdm0... (CID: 19)
Dec 07 00:55:13 rockpi-e start_LTE_QMI.sh[1703]: Saving state at /tmp/qmi-network-state-cdc-wdm0... (PDH: 1654799168)
Dec 07 00:55:13 rockpi-e start_LTE_QMI.sh[1703]: Network started successfully
Dec 07 00:55:13 rockpi-e start_LTE_QMI.sh[1727]: [/dev/cdc-wdm0] Current settings retrieved:
Dec 07 00:55:13 rockpi-e start_LTE_QMI.sh[1727]:            IP Family: IPv4
Dec 07 00:55:13 rockpi-e start_LTE_QMI.sh[1727]:         IPv4 address: 10.240.212.143
Dec 07 00:55:13 rockpi-e start_LTE_QMI.sh[1727]:     IPv4 subnet mask: 255.255.255.224
Dec 07 00:55:13 rockpi-e start_LTE_QMI.sh[1727]: IPv4 gateway address: 10.240.212.144
Dec 07 00:55:13 rockpi-e start_LTE_QMI.sh[1727]:     IPv4 primary DNS: 10.112.248.230
Dec 07 00:55:13 rockpi-e start_LTE_QMI.sh[1727]:   IPv4 secondary DNS: 10.112.248.242
Dec 07 00:55:13 rockpi-e start_LTE_QMI.sh[1727]:                  MTU: 1500
Dec 07 00:55:13 rockpi-e start_LTE_QMI.sh[1727]:              Domains: none
Dec 07 00:55:13 rockpi-e start_LTE_QMI.sh[1305]: Waiting for network registration
Dec 07 00:55:15 rockpi-e start_LTE_QMI.sh[1305]: Registration state: 'registered'
Dec 07 00:55:15 rockpi-e start_LTE_QMI.sh[1305]: Starting network: 'wwanlte'
Dec 07 00:55:15 rockpi-e start_LTE_QMI.sh[1739]: udhcpc: started, v1.30.1
Dec 07 00:55:15 rockpi-e udhcpc[1746]: wwanlte: deconfigured
Dec 07 00:55:15 rockpi-e start_LTE_QMI.sh[1739]: udhcpc: sending discover
Dec 07 00:55:16 rockpi-e start_LTE_QMI.sh[1739]: udhcpc: sending select for 10.240.212.143
Dec 07 00:55:16 rockpi-e start_LTE_QMI.sh[1739]: udhcpc: lease of 10.240.212.143 obtained, lease time 7200
Dec 07 00:55:16 rockpi-e start_LTE_QMI.sh[1772]: /etc/resolvconf/update.d/libc: Warning: /etc/resolv.conf is not a symbolic link to /run/resolvconf/resolv.conf
Dec 07 00:55:16 rockpi-e udhcpc[1785]: wwanlte: bound: IP=10.240.212.143/255.255.255.224 router=10.240.212.144 domain="" dns="10.112.248.230 10.112.248.242" lease=7200
Dec 07 00:55:16 rockpi-e start_LTE_QMI.sh[1305]: Done!
Dec 07 00:55:16 rockpi-e systemd[1]: LTE-modem-starter.service: Succeeded.
Dec 07 00:55:16 rockpi-e systemd[1]: LTE-modem-starter.service: Consumed 1.169s CPU time.
```
```
# ip addr show wwanlte
5: wwanlte: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 1000
    link/none
    inet 10.240.212.143/27 scope global wwanlte
       valid_lft forever preferred_lft forever
```

---
Good luck!  
Alexey Tsarev  
https://alexey-tsarev.github.io  
Tsarev.Alexey at gmail.com
