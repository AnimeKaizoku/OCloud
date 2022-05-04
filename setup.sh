#!/bin/bash

set -e

if [[ -z "$1" ]]; then
    echo "Usage: $0 <hostname>" >&2
    exit 1
fi

set -x
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y neofetch speedtest-cli python3{,-pip} fail2ban iptables-persistent
sudo apt autoremove -y

GOTAR=$(mktemp)
wget --output-document="$GOTAR" https://go.dev/dl/go1.18.1.linux-arm64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "$GOTAR"
rm "$GOTAR"
echo "export PATH='\$PATH:/usr/local/go/bin'" | sudo tee /etc/profile.d/ocloud-go.sh
sudo chmod +x /etc/profile.d/ocloud-go.sh

sudo systemctl enable fail2ban
systemctl status fail2ban
sudo sed -i '/preserve_hostname: false/c\preserve_hostname: true' /etc/cloud/cloud.cfg
sudo hostnamectl set-hostname "$1"
neofetch # generate config file
patch ~/.config/neofetch/config.conf << EOF
--- a/.config/neofetch/config.conf      2022-02-27 06:16:27.191454225 +0000
+++ b/.config/neofetch/config.conf      2022-05-03 08:12:09.591378125 +0000
@@ -6,7 +6,7 @@

     info "OS" distro
     info "Host" model
-    info "Kernel" kernel
+    # info "Kernel" kernel
     info "Uptime" uptime
     info "Packages" packages
     info "Shell" shell
@@ -23,8 +23,8 @@
     info "Memory" memory

     # info "GPU Driver" gpu_driver  # Linux/macOS only
-    # info "CPU Usage" cpu_usage
-    # info "Disk" disk
+    info "CPU Usage" cpu_usage
+    info "Disk" disk
     # info "Battery" battery
     # info "Font" font
     # info "Song" song
EOF
sudo chmod -x /etc/update-motd.d/*
sudo iptables-save -f /etc/iptables/rules.v4
sudo ip6tables-save -f /etc/iptables/rules.v6
