#!/bin/bash

set -e
BASICSET=0
HOSTNAME=""
DEFAULTDE=gnome
DEFAULTDESET=0
# empty strings will be set to DEFAULTDE
VNC=""
VNCSET=0
RDP=""
RDPSET=0

DEBNI="DEBIAN_FRONTEND=noninteractive"
PROGNAME="$0"
function validde() {
    [[ "$@" = xfce || "$@" = gnome || "$@" = kde || -z "$@" ]]
}
function depackages() {
    case "$@" in
        "xfce")
            echo "xfce4{,-goodies}"
        ;;
        "gnome")
            echo "ubuntu-desktop gnome-session"
        ;;
        "kde")
            echo "kde-plasma-desktop"
        ;;
        *)
            echoe "Unknown DE \"$@\" passed into depackages"
            exit 1
        ;;
    esac
}
function decommand() {
    case "$@" in
        "xfce")
            echo "exec startxfce4"
        ;;
        "gnome")
            echo "XDG_SESSION_TYPE=x11 GDK_BACKEND=x11 exec gnome-session"
        ;;
        "kde")
            echo "DESKTOP_SESSION=plasma exec startplasma-x11"
        ;;
        *)
            echoe "Unknown DE \"$@\" passed into decommand"
            exit 1
        ;;
    esac
}
function echoe() {
    echo "$@" >&2
}
function writeenvreset() {
    if [[ ! -e /etc/X11/Xsession.d/10ocloud-envvars ]]; then
        echo "unset DBUS_SESSION_BUS_ADDRESS XDG_RUNTIME_DIR" | sudo tee /etc/X11/Xsession.d/10ocloud-envvars
    fi
}
function usage() {
    echoe "Usage: $PROGNAME [--basic=<new hostname>] [--de=xfce|gnome|kde] [--vnc +=[de]] [--rdp=[de]]"
    echoe "Options:"
    echoe "    -b, --basic: Run basic setup"
    echoe "    -d, --de: Set default DE for VNC and RDP (default: gnome)"
    echoe "    -v, --vnc: Run VNC setup (interaction needed for password if not set)"
    echoe "    -r, --rdp: Run RDP setup"
    exit 1
}

# getopt usage stolen from /usr/share/doc/util-linux/getopt-example.bash
set +e # we want rc from getopt
GETOPT_RES=$(getopt -o "b:d:v::r::" --long "basic:,de:,vnc::,rdp::" -n "$PROGNAME" -- "$@")
set -e
GETOPT_EC=$?
[[ $GETOPT_EC -eq 1 ]] && usage
[[ $GETOPT_EC -ne 0 ]] && exit $GETOPT_EC
eval set -- "$GETOPT_RES"
unset GETOPT_RES GETOPT_EC

while true; do
    case "$1" in
        "-b"|"--basic")
            if [[ $BASICSET -ne 0 ]]; then
                echoe "$1 cannot be passed multiple times"
                usage
            fi
            BASICSET=1
            HOSTNAME="$2"
            shift 2
            continue
        ;;
        "-d"|"--de")
            if [[ $DEFAULTDESET -ne 0 ]]; then
                echoe "$1 cannot be passed multiple times"
                usage
            fi
            validde $2 || (echoe "Unknown DE: $2" && usage)
            DEFAULTDE="$2"
            DEFAULTDESET=1
            shift 2
            continue
        ;;
        "-v"|"--vnc")
            if [[ $VNCSET -ne 0 ]]; then
                echoe "$1 cannot be passed multiple times"
                usage
            fi
            validde $2 || (echoe "Unknown DE: $2" && usage)
            VNC="$2"
            VNCSET=1
            shift 2
            continue
        ;;
        "-r"|"--rdp")
            if [[ $RDPSET -ne 0 ]]; then
                echoe "$1 cannot be passed multiple times"
                usage
            fi
            validde $2 || (echoe "Unknown DE: $2" && usage)
            RDP="$2"
            RDPSET=1
            shift 2
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
[[ $(($BASICSET + $VNCSET + $RDPSET)) -eq 0 ]] && usage
[[ $# -ne 0 ]] && echoe "Received unknown arguments" && usage
[[ -z "$VNC" ]] && VNC=$DEFAULTDE
[[ -z "$RDP" ]] && RDP=$DEFAULTDE

if [[ $BASICSET -eq 1 ]]; then
    echoe "+++ Basic setup"

    echoe "+ Updating repositories"
    sudo $DEBNI apt-get update -y
    echoe "+ Updating packages"
    sudo $DEBNI apt-get upgrade -y
    echoe "+ Installing packages"
    sudo $DEBNI apt-get install -y neofetch speedtest-cli python3{,-pip} fail2ban iptables-persistent ffmpeg
    echoe "+ Removing unused dependencies"
    sudo $DEBNI apt-get autoremove -y

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

if [[ $VNCSET -eq 1 ]]; then
    echoe "+++ VNC setup (you may be prompted for your VNC password)"

    echoe "+ Installing dependencies"
    sudo $DEBNI apt-get install -y $(depackages $VNC) tigervnc-standalone-server

    echoe "+ Adding files"
    # Modified https://wiki.archlinux.org/title/TigerVNC#systemd_service_unit_run_as_user
[[ ! -e /usr/lib/systemd/user/tigervnc@.service ]] &&
sudo tee /usr/lib/systemd/user/tigervnc@.service > /dev/null << EOF
[Unit]
Description=Remote desktop service (VNC)
After=syslog.target network.target

[Service]
Type=simple
# https://github.com/TigerVNC/tigervnc/issues/800#issuecomment-565669421
Environment=LD_PRELOAD=/lib/aarch64-linux-gnu/libgcc_s.so.1
ExecStart=/usr/bin/tigervncserver -depth 24 -geometry 1280x800 -localhost -fg %i

[Install]
WantedBy=default.target
EOF

    mkdir -p ~/.vnc
    if [[ ! -e ~/.vnc/ocloud-vncde ]]; then
        [[ -e ~/.vnc/xstartup ]] && mv ~/.vnc/xstartup{,.oc}
        echo "#!/bin/sh" > ~/.vnc/xstartup
        echo "~/.vnc/ocloud-vncde" >> ~/.vnc/xstartup
        echo 'tigervncserver -kill $DISPLAY' >> ~/.vnc/xstartup
        chmod +x ~/.vnc/xstartup
    fi
    echo "#!/bin/sh" > ~/.vnc/ocloud-vncde
    echo "# Entire file auto-generated by ocloud" >> ~/.vnc/ocloud-vncde
    decommand $VNC >> ~/.vnc/ocloud-vncde
    chmod +x ~/.vnc/ocloud-vncde
    writeenvreset

    if [[ ! -e ~/.vnc/passwd ]]; then
        echoe "+ Setting VNC password (password not echoed back)"
        vncpasswd >&2
    fi

    echoe "+ Staring vncserver"
    systemctl --user daemon-reload
    systemctl --user enable --now tigervnc@:1
    # https://unix.stackexchange.com/a/559755
    sudo loginctl enable-linger "$(id -un)"
fi

if [[ $RDPSET -eq 1 ]]; then
    echoe "+++ RDP setup"

    echoe "+ Installing dependencies"
    sudo $DEBNI apt-get install -y $(depackages $RDP) xrdp
    sudo usermod -aG ssl-cert xrdp

    echoe "+ Adding files"
    sudo sed -i -E 's/^new_cursors=true/new_cursors=false/' /etc/xrdp/xrdp.ini
    if [[ ! -e ~/.xsessionrc ]]; then
        echo "#!/bin/sh" > ~/.xsessionrc
        echo "$(decommand $RDP) # Line auto-generated by ocloud" >> ~/.xsessionrc
        chmod +x ~/.xsessionrc
    else
        grep -q ". # Line auto-generated by ocloud$" ~/.xsessionrc ||
            (echoe "Failed to locate DE line in .xsessionrc" && exit 1)
        sed -i -E "s/.+( # Line auto-generated by ocloud)\$/$(decommand $RDP)\1/" ~/.xsessionrc
    fi
    writeenvreset

    sudo systemctl restart xrdp
    echoe "xrdp uses the account's password to login. To change it, run"
    echoe "\"sudo passwd $(id -un)\" (your password won't be echoed back)"
fi
