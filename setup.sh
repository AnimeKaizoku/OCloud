#!/bin/bash

set -e
BASIC=0
VNC=0
RDP=0
HOSTNAME=""
function echoe() {
    echo "$@" >&2
}
function usage() {
    echoe "Usage: ./setup.sh [-bvr] [hostname]"
    echoe "Options:"
    echoe "    -b: Run basic setup, implicitly set if no arguments are passed"
    echoe "    -v: Run VNC setup"
    echoe "    -r: Run RDP setup"
    echoe "Arguments:"
    echoe "    hostname: To be set hostname of the machine, required if -b is set"
    exit 1
}

# getopt usage stolen from /usr/share/doc/util-linux/getopt-example.bash
GETOPT_RES=$(getopt bvr $@)
GETOPT_EC=$?
[[ $GETOPT_EC -eq 1 ]] && usage
[[ $GETOPT_EC -ne 0 ]] && exit $GETOPT_EC
eval set -- "$GETOPT_RES"
unset GETOPT_RES GETOPT_EC
while true; do
    case "$1" in
        "-b")
            if [[ $BASIC -ne 0 ]]; then
                echoe "-b cannot be passed multiple times"
                usage
            fi
            BASIC=1
            shift
            continue
        ;;
        "-v")
            if [[ $VNC -ne 0 ]]; then
                echoe "-v cannot be passed multiple times"
                usage
            fi
            VNC=1
            shift
            continue
        ;;
        "-r")
            if [[ $RDP -ne 0 ]]; then
                echoe "-r cannot be passed multiple times"
                usage
            fi
            RDP=1
            shift
            continue
        ;;
        "--")
            shift
            break
        ;;
        *)
            echoe "Unknown argument received from getopt: '$1'"
            exit 1
        ;;
    esac
done
[[ $(($BASIC + $VNC + $RDP)) -eq 0 ]] && BASIC=1
[[ $# -gt 1 ]] && usage
HOSTNAME="$1"

if [[ $BASIC -eq 1 ]]; then
    echoe "+++ Basic setup"
    if [[ -z "$HOSTNAME" ]]; then
        echoe "No hostname passed while doing basic setup"
        usage
    fi

    echoe "+ Updating repositories"
    sudo apt-get update -y
    echoe "+ Updating packages"
    sudo apt-get upgrade -y
    echoe "+ Installing packages"
    sudo apt-get install -y neofetch speedtest-cli python3{,-pip} fail2ban iptables-persistent
    echoe "+ Removing unused dependencies"
    sudo apt-get autoremove -y

    echoe "+ Downloading go 1.18.1"
    GOTAR=$(mktemp)
    wget --output-document="$GOTAR" https://go.dev/dl/go1.18.1.linux-arm64.tar.gz
    echoe "+ Deleting go"
    sudo rm -rf /usr/local/go
    echoe "+ Extracting go"
    sudo tar -C /usr/local -xzf "$GOTAR"
    rm "$GOTAR"
    echo "export PATH=\"\$PATH:/usr/local/go/bin\"" | sudo tee /etc/profile.d/ocloud-go.sh > /dev/null
    sudo chmod +x /etc/profile.d/ocloud-go.sh

    echoe "+ Enabling fail2ban"
    sudo systemctl enable fail2ban
    systemctl status fail2ban
    echoe "+ Setting hostname to $HOSTNAME"
    sudo sed -i '/preserve_hostname: false/c\preserve_hostname: true' /etc/cloud/cloud.cfg
    sudo hostnamectl set-hostname -- "$HOSTNAME"
    echoe "+ Patching neofetch config"
    mkdir -p ~/.config/neofetch
    neofetch --print_config > ~/.config/neofetch/config.conf
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
    echoe "+ Disabling MOTD"
    sudo chmod -x /etc/update-motd.d/*
    echoe "+ Saving iptables config"
    sudo iptables-save -f /etc/iptables/rules.v4
    sudo ip6tables-save -f /etc/iptables/rules.v6
fi

if [[ $VNC -eq 1 ]]; then
    echoe "+++ VNC setup"
    echoe "it's not finished"
    exit 1
fi

if [[ $RDP -eq 1 ]]; then
    echoe "+++ RDP setup"
    echoe "it's not finished"
    exit 1
fi
