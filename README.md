# LTE modem starter
This repository is a pack of scripts to run LTE modem in Linux.

I use:
- DW5821e
- ROCK Pi E D4W1 https://wiki.radxa.com/RockpiE/hardware/models
- Armbian Bullseye https://www.armbian.com/rockpie/

Logs example:
```
# cat /var/log/syslog
...
Dec  6 01:37:55 rockpi-e udev: Device: 'Dell_Inc._DW5821e_Snapdragon_X20_LTE_0123456789ABCDEF', path: '/sys/devices/platform/ff600000.usb/xhci-hcd.0.auto/usb5/5-1', config mode: '2'
Dec  6 01:37:55 rockpi-e udev: Create file: '/var/tmp/LTE-modem-device-path.txt'
Dec  6 01:37:55 rockpi-e udev: Run service: 'LTE-modem-starter'
...
```
```
# journalctl -b --no-pager -u LTE-modem-starter
-- Journal begins at Mon 2021-12-06 01:09:11 +04, ends at Mon 2021-12-06 01:45:01 +04. --
Dec 06 01:39:49 rockpi-e systemd[1]: Started Run LTE modem in QMI mode.
Dec 06 01:39:49 rockpi-e start_LTE_QMI.sh[1356]: Attempt: 1
Dec 06 01:39:49 rockpi-e start_LTE_QMI.sh[1356]: Device: '/sys/devices/platform/ff600000.usb/xhci-hcd.0.auto/usb5/5-1/bConfigurationValue', config mode: '2'
Dec 06 01:39:49 rockpi-e start_LTE_QMI.sh[1356]: Setting device to use QMI: '/sys/devices/platform/ff600000.usb/xhci-hcd.0.auto/usb5/5-1/bConfigurationValue'
Dec 06 01:39:50 rockpi-e start_LTE_QMI.sh[1356]: Finding device
Dec 06 01:39:50 rockpi-e start_LTE_QMI.sh[1356]: Device: '/dev/cdc-wdm0'
Dec 06 01:39:50 rockpi-e start_LTE_QMI.sh[1356]: Getting interface
Dec 06 01:39:53 rockpi-e start_LTE_QMI.sh[1356]: Interface: 'wwan0'
Dec 06 01:39:53 rockpi-e start_LTE_QMI.sh[1356]: Stopping qmi-network at '/dev/cdc-wdm0'
Dec 06 01:39:53 rockpi-e start_LTE_QMI.sh[1860]: Profile at '/etc/qmi-network.conf' not found...
Dec 06 01:39:53 rockpi-e start_LTE_QMI.sh[1860]: Network already stopped
Dec 06 01:39:53 rockpi-e start_LTE_QMI.sh[1860]: Clearing state at /tmp/qmi-network-state-cdc-wdm0...
Dec 06 01:39:53 rockpi-e start_LTE_QMI.sh[1356]: Waiting for SIM initialization
Dec 06 01:39:53 rockpi-e start_LTE_QMI.sh[2000]: [/dev/cdc-wdm0] Network started
Dec 06 01:39:53 rockpi-e start_LTE_QMI.sh[2000]:         Packet data handle: '1246693600'
Dec 06 01:39:53 rockpi-e start_LTE_QMI.sh[2000]: [/dev/cdc-wdm0] Client ID not released:
Dec 06 01:39:53 rockpi-e start_LTE_QMI.sh[2000]:         Service: 'wds'
Dec 06 01:39:53 rockpi-e start_LTE_QMI.sh[2000]:             CID: '18'
Dec 06 01:39:53 rockpi-e start_LTE_QMI.sh[2005]: [/dev/cdc-wdm0] Operating mode set successfully
Dec 06 01:39:53 rockpi-e start_LTE_QMI.sh[1356]: Starting qmi-network at '/dev/cdc-wdm0'
Dec 06 01:39:53 rockpi-e start_LTE_QMI.sh[2010]: Profile at '/etc/qmi-network.conf' not found...
Dec 06 01:39:53 rockpi-e start_LTE_QMI.sh[2010]: Checking data format with 'qmicli -d /dev/cdc-wdm0 --wda-get-data-format '...
Dec 06 01:39:54 rockpi-e start_LTE_QMI.sh[2010]: Device link layer protocol retrieved: raw-ip
Dec 06 01:39:54 rockpi-e start_LTE_QMI.sh[2010]: Getting expected data format with 'qmicli -d /dev/cdc-wdm0 --get-expected-data-format'...
Dec 06 01:39:54 rockpi-e start_LTE_QMI.sh[2010]: Expected link layer protocol retrieved: raw-ip
Dec 06 01:39:54 rockpi-e start_LTE_QMI.sh[2010]: Device and kernel link layer protocol match: raw-ip
Dec 06 01:39:54 rockpi-e start_LTE_QMI.sh[2010]: Starting network with 'qmicli -d /dev/cdc-wdm0 --wds-start-network=  --client-no-release-cid '...
Dec 06 01:39:54 rockpi-e start_LTE_QMI.sh[2010]: Saving state at /tmp/qmi-network-state-cdc-wdm0... (CID: 19)
Dec 06 01:39:54 rockpi-e start_LTE_QMI.sh[2010]: Saving state at /tmp/qmi-network-state-cdc-wdm0... (PDH: 1248218800)
Dec 06 01:39:54 rockpi-e start_LTE_QMI.sh[2010]: Network started successfully
Dec 06 01:39:54 rockpi-e start_LTE_QMI.sh[2043]: [/dev/cdc-wdm0] Current settings retrieved:
Dec 06 01:39:54 rockpi-e start_LTE_QMI.sh[2043]:            IP Family: IPv4
Dec 06 01:39:54 rockpi-e start_LTE_QMI.sh[2043]:         IPv4 address: 100.110.14.173
Dec 06 01:39:54 rockpi-e start_LTE_QMI.sh[2043]:     IPv4 subnet mask: 255.255.255.252
Dec 06 01:39:54 rockpi-e start_LTE_QMI.sh[2043]: IPv4 gateway address: 100.110.14.174
Dec 06 01:39:54 rockpi-e start_LTE_QMI.sh[2043]:     IPv4 primary DNS: 10.112.248.230
Dec 06 01:39:54 rockpi-e start_LTE_QMI.sh[2043]:   IPv4 secondary DNS: 10.112.248.242
Dec 06 01:39:54 rockpi-e start_LTE_QMI.sh[2043]:                  MTU: 1500
Dec 06 01:39:54 rockpi-e start_LTE_QMI.sh[2043]:              Domains: none
Dec 06 01:39:54 rockpi-e start_LTE_QMI.sh[1356]: Waiting for network registration
Dec 06 01:39:55 rockpi-e start_LTE_QMI.sh[1356]: Registration state: 'registered'
Dec 06 01:39:55 rockpi-e start_LTE_QMI.sh[1356]: Starting network wwan0
Dec 06 01:39:55 rockpi-e start_LTE_QMI.sh[2077]: udhcpc: started, v1.30.1
Dec 06 01:40:03 rockpi-e start_LTE_QMI.sh[2077]: udhcpc: sending discover
Dec 06 01:40:03 rockpi-e start_LTE_QMI.sh[2077]: udhcpc: sending select for 100.110.14.173
Dec 06 01:40:03 rockpi-e start_LTE_QMI.sh[2077]: udhcpc: lease of 100.110.14.173 obtained, lease time 7200
Dec 06 01:40:03 rockpi-e start_LTE_QMI.sh[2113]: /etc/resolvconf/update.d/libc: Warning: /etc/resolv.conf is not a symbolic link to /run/resolvconf/resolv.conf
Dec 06 01:40:03 rockpi-e udhcpc[2127]: wwan0: bound: IP=100.110.14.173/255.255.255.252 router=100.110.14.174 domain="" dns="10.112.248.230 10.112.248.242" lease=7200
Dec 06 01:40:03 rockpi-e start_LTE_QMI.sh[1356]: Done!
Dec 06 01:40:03 rockpi-e systemd[1]: LTE-modem-starter.service: Succeeded.
Dec 06 01:40:03 rockpi-e systemd[1]: LTE-modem-starter.service: Consumed 1.041s CPU time.
```

---
Good luck!  
Alexey Tsarev  
https://alexey-tsarev.github.io  
Tsarev.Alexey at gmail.com
