# LTE modem starter
This repository is a pack of scripts to run LTE modem in Linux.

I use:
- DW5821e
- ROCK Pi E D4W1 https://wiki.radxa.com/RockpiE/hardware/models
- Armbian Bullseye https://www.armbian.com/rockpie/

## Install
```
# apt install wget libqmi-utils libmbim-utils udhcpc socat
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

Reload services (you don't need to enable "LTE-modem-starter" service)
```
# systemctl daemon-reload
```

Reattach your LTE modem (when it connected to a USB port) or reboot your machine and look at logs:
```
tail -n +1 -f /var/log/syslog
```

## Logs example
```
# journalctl -b --no-pager
...
Dec 09 00:17:30 rockpi-e udev[549]: Device: 'Dell_Inc._DW5821e_Snapdragon_X20_LTE_0123456789ABCDEF', path: '/sys/devices/platform/ff600000.usb/xhci-hcd.0.auto/usb5/5-1/bConfigurationValue', current config value: '2'
Dec 09 00:17:30 rockpi-e udev[555]: Write to file: '/var/tmp/LTE-modem-device-path.txt'
Dec 09 00:17:30 rockpi-e udev[557]: Start service: 'LTE-modem-starter'
...
Dec 09 00:19:31 rockpi-e kernel: cdc_mbim 5-1:2.0 wwanlte: renamed from wwan0
...
```
```
# journalctl -b --no-pager -u LTE-modem-starter
-- Journal begins at Thu 2021-12-09 00:10:02 +04, ends at Thu 2021-12-09 00:21:16 +04. --
Dec 09 00:19:28 rockpi-e systemd[1]: Started Run LTE modem.
Dec 09 00:19:29 rockpi-e start_LTE_modem.sh[1405]: Attempt: 1
Dec 09 00:19:29 rockpi-e start_LTE_modem.sh[1405]: Device: '/sys/devices/platform/ff600000.usb/xhci-hcd.0.auto/usb5/5-1/bConfigurationValue', current config value: '2'
Dec 09 00:19:29 rockpi-e start_LTE_modem.sh[1405]: Device config value is already set
Dec 09 00:19:29 rockpi-e start_LTE_modem.sh[1405]: Find device
Dec 09 00:19:29 rockpi-e start_LTE_modem.sh[1419]: find: ‘/sys/devices/platform/ff600000.usb/xhci-hcd.0.auto/usb5/5-1/*/usbmisc/*’: No such file or directory
Dec 09 00:19:29 rockpi-e start_LTE_modem.sh[1405]: Error: 'device_only' is not found
Dec 09 00:19:29 rockpi-e start_LTE_modem.sh[1405]: Retry
Dec 09 00:19:30 rockpi-e start_LTE_modem.sh[1405]: Attempt: 2
Dec 09 00:19:30 rockpi-e start_LTE_modem.sh[1405]: Device: '/sys/devices/platform/ff600000.usb/xhci-hcd.0.auto/usb5/5-1/bConfigurationValue', current config value: '2'
Dec 09 00:19:30 rockpi-e start_LTE_modem.sh[1405]: Set device: '/sys/devices/platform/ff600000.usb/xhci-hcd.0.auto/usb5/5-1/bConfigurationValue', config value: '2'
Dec 09 00:19:31 rockpi-e start_LTE_modem.sh[1405]: Find device
Dec 09 00:19:31 rockpi-e start_LTE_modem.sh[1405]: Device: '/dev/cdc-wdm0'
Dec 09 00:19:31 rockpi-e start_LTE_modem.sh[1405]: Get interface
Dec 09 00:19:31 rockpi-e start_LTE_modem.sh[1405]: Interface: 'wwanlte'
Dec 09 00:19:31 rockpi-e start_LTE_modem.sh[1405]: Stop mbim-network at '/dev/cdc-wdm0'
Dec 09 00:19:31 rockpi-e start_LTE_modem.sh[1730]: Profile at '/etc/mbim-network.conf' not found...
Dec 09 00:19:31 rockpi-e start_LTE_modem.sh[1730]: Stopping network with 'mbimcli -d /dev/cdc-wdm0 --disconnect '...
Dec 09 00:19:32 rockpi-e start_LTE_modem.sh[1738]: error: operation failed: ContextNotActivated
Dec 09 00:19:32 rockpi-e start_LTE_modem.sh[1730]: Network stop failed
Dec 09 00:19:32 rockpi-e start_LTE_modem.sh[1730]: Clearing state at /tmp/mbim-network-state-cdc-wdm0...
Dec 09 00:19:32 rockpi-e start_LTE_modem.sh[1405]: Wait for SIM initialization
Dec 09 00:19:32 rockpi-e start_LTE_modem.sh[1405]: Start mbim-network at '/dev/cdc-wdm0'
Dec 09 00:19:32 rockpi-e start_LTE_modem.sh[1807]: Profile at '/etc/mbim-network.conf' not found...
Dec 09 00:19:32 rockpi-e start_LTE_modem.sh[1807]: Querying subscriber ready status 'mbimcli -d /dev/cdc-wdm0 --query-subscriber-ready-status --no-close '...
Dec 09 00:19:32 rockpi-e start_LTE_modem.sh[1807]: [/dev/cdc-wdm0] Subscriber ready status retrieved: Ready state: 'initialized' Subscriber ID: '250027367621340' SIM ICCID: '897010273676213408FF' Ready info: 'none' Telephone numbers: (1) '+79378069192' [/dev/cdc-wdm0] Session not closed: TRID: '3'
Dec 09 00:19:32 rockpi-e start_LTE_modem.sh[1807]: Saving state at /tmp/mbim-network-state-cdc-wdm0... (TRID: 3)
Dec 09 00:19:32 rockpi-e start_LTE_modem.sh[1807]: Querying registration state 'mbimcli -d /dev/cdc-wdm0 --query-registration-state --no-open=3 --no-close '...
Dec 09 00:19:33 rockpi-e start_LTE_modem.sh[1807]: [/dev/cdc-wdm0] Registration status: Network error: 'unknown' Register state: 'home' Register mode: 'automatic' Available data classes: 'lte' Current cellular class: 'gsm' Provider ID: '25002' Provider name: 'MegaFon' Roaming text: 'unknown' Registration flags: 'packet-service-automatic-attach' [/dev/cdc-wdm0] Session not closed: TRID: '4'
Dec 09 00:19:33 rockpi-e start_LTE_modem.sh[1807]: Saving state at /tmp/mbim-network-state-cdc-wdm0... (TRID: 4)
Dec 09 00:19:33 rockpi-e start_LTE_modem.sh[1807]: Attaching to packet service with 'mbimcli -d /dev/cdc-wdm0 --attach-packet-service --no-open=4 --no-close '...
Dec 09 00:19:33 rockpi-e start_LTE_modem.sh[1807]: Saving state at /tmp/mbim-network-state-cdc-wdm0... (TRID: 5)
Dec 09 00:19:33 rockpi-e start_LTE_modem.sh[1807]: Starting network with 'mbimcli -d /dev/cdc-wdm0 --connect=apn='' --no-open=5 --no-close '...
Dec 09 00:19:33 rockpi-e start_LTE_modem.sh[1807]: Network started successfully
Dec 09 00:19:33 rockpi-e start_LTE_modem.sh[1807]: Saving state at /tmp/mbim-network-state-cdc-wdm0... (TRID: 7)
Dec 09 00:19:33 rockpi-e start_LTE_modem.sh[1405]: Wait for network registration
Dec 09 00:19:33 rockpi-e start_LTE_modem.sh[1857]: [/dev/cdc-wdm0] Home provider:
Dec 09 00:19:33 rockpi-e start_LTE_modem.sh[1857]:            Provider ID: '25002'
Dec 09 00:19:33 rockpi-e start_LTE_modem.sh[1857]:          Provider name: 'MegaFon'
Dec 09 00:19:33 rockpi-e start_LTE_modem.sh[1857]:                  State: 'home'
Dec 09 00:19:33 rockpi-e start_LTE_modem.sh[1857]:         Cellular class: 'gsm'
Dec 09 00:19:33 rockpi-e start_LTE_modem.sh[1857]:                   RSSI: '99'
Dec 09 00:19:33 rockpi-e start_LTE_modem.sh[1857]:             Error rate: '99'
Dec 09 00:19:33 rockpi-e start_LTE_modem.sh[1857]: [/dev/cdc-wdm0] Session not closed:
Dec 09 00:19:33 rockpi-e start_LTE_modem.sh[1857]:             TRID: '1638994774'
Dec 09 00:19:33 rockpi-e start_LTE_modem.sh[1405]: Start DHCP client at interface: 'wwanlte'
Dec 09 00:19:33 rockpi-e start_LTE_modem.sh[1860]: udhcpc: started, v1.30.1
Dec 09 00:19:33 rockpi-e udhcpc[1867]: wwanlte: deconfigured
Dec 09 00:19:33 rockpi-e start_LTE_modem.sh[1860]: udhcpc: sending discover
Dec 09 00:19:33 rockpi-e start_LTE_modem.sh[1860]: udhcpc: sending select for 100.67.233.65
Dec 09 00:19:33 rockpi-e start_LTE_modem.sh[1860]: udhcpc: lease of 100.67.233.65 obtained, lease time 7200
Dec 09 00:19:33 rockpi-e start_LTE_modem.sh[1893]: /etc/resolvconf/update.d/libc: Warning: /etc/resolv.conf is not a symbolic link to /run/resolvconf/resolv.conf
Dec 09 00:19:33 rockpi-e udhcpc[1906]: wwanlte: bound: IP=100.67.233.65/255.255.255.252 router=100.67.233.66 domain="" dns="10.112.248.250 10.112.248.226" lease=7200
Dec 09 00:19:33 rockpi-e start_LTE_modem.sh[1907]: 6: wwanlte: <BROADCAST,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 1000
Dec 09 00:19:33 rockpi-e start_LTE_modem.sh[1907]:     link/ether fa:3e:70:9c:b9:db brd ff:ff:ff:ff:ff:ff
Dec 09 00:19:33 rockpi-e start_LTE_modem.sh[1907]:     inet 100.67.233.65/30 brd 100.67.233.67 scope global wwanlte
Dec 09 00:19:33 rockpi-e start_LTE_modem.sh[1907]:        valid_lft forever preferred_lft forever
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1909]: AT^DEBUG?
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1909]: RAT:LTE
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1909]: EARFCN(DL/UL): 2850/20850
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1909]: BAND: 7
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1909]: BW: 20.0 MHz
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1909]: PLMN: 250 02
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1909]: TAC: 6420
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1909]: eNB ID(PCI): 645413-2(21)
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1909]: ESM CAUSE: 0
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1909]: EMM CAUSE: -1
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1909]: DRX: 1280ms
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1909]: RSRP: -98.0dBm rx_diversity: 3 (-98.0dBm,-102.7dBm,-256.0dBm,-256.0dBm)
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1909]: RSRQ: -10.6dB
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1909]: RSSI: -67.4dBm
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1909]: L2W:  -118
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1909]: RI: 1
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1909]: CQI:  10
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1909]: RS-SNR: 2dB
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1909]: STATUS: SRV/REGISTERED
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1909]: SUB STATUS: NORMAL_SERVICE
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1909]: RRC Status: IDLE
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1909]: SVC: CS_PS
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1909]: Tx Pwr: -
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1909]: TMSI: 7216811954
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1909]: IP: 100.67.233.65
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1909]: AVG RSRP: -98.0dBm
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1909]: OK
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1913]: AT^CA_INFO?
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1913]: PCC info: Band is LTE_B7, Band_width is 20.0 MHz
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1913]: SCC1 info: Band is LTE_B7, Band_width is 20.0 MHz
Dec 09 00:19:34 rockpi-e start_LTE_modem.sh[1913]: OK
Dec 09 00:19:35 rockpi-e systemd[1]: LTE-modem-starter.service: Succeeded.
Dec 09 00:19:35 rockpi-e systemd[1]: LTE-modem-starter.service: Consumed 1.084s CPU time.
```
---
Good luck!  
Alexey Tsarev  
https://alexey-tsarev.github.io  
Tsarev.Alexey at gmail.com
