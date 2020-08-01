#!/bin/sh

printf "lan\tplatform-1c1b000.usb-usb-0:1:1.0\nwan\tplatform-1c30000.ethernet\nwlan\tplatform-1c10000.mmc\n" | while read iface path; do
cat << EOF > /etc/systemd/network/10-$iface.link
[Match]
Path=$path

[Link]
Name=$iface
EOF
done

cat << EOF >> /etc/NetworkManager/NetworkManager.conf

[keyfile]
unmanaged-devices=interface-name:wan,interface-name:lan,interface-name:wlan0,interface-name:wlan1

EOF

echo mac80211_hwsim > /etc/modules
echo br_nefilter >> /etc/modules

# systemctl disable serial-getty@ttyGS0.service

apt update
apt install -y python3-setuptools python3-dev libpcap-dev

cp pitm-systctl.conf /etc/sysctl.d/
