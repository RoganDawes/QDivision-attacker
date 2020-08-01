#!/bin/sh
cd $( cd $(dirname $0) && pwd)

printf "lan\tplatform-1c1b000.usb-usb-0:1:1.0\nwan\tplatform-1c30000.ethernet\nwlan\tplatform-1c10000.mmc\n" | while read iface path; do
cat << EOF > /etc/systemd/network/10-$iface.link
[Match]
Path=$path

[Link]
Name=$iface
EOF
done

cp NetworkManager.conf /etc/NetworkManager/NetworkManager.conf

echo mac80211_hwsim > /etc/modules
echo br_nefilter >> /etc/modules

# systemctl disable serial-getty@ttyGS0.service

apt update
DEBIAN_FRONTEND=noninteractive apt install -y python3-setuptools python3-dev libpcap-dev
DEBIAN_FRONTEND=noninteractive apt install -y iftop dnsmasq tcpdump ebtables redsocks macchanger
DEBIAN_FRONTEND=noninteractive apt install -y python3-pypcap python3-dpkt python3-pyroute2 python3-iptables python3-cffi

cp pitm-sysctl.conf /etc/sysctl.d/
