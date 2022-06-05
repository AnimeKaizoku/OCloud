#!/bin/bash

set -e
function echoe() {
    echo $@ >&2
}

echoe "+ Downloading plex"
DOWNLOAD_URL=$(curl --silent --show-errors https://plex.tv/api/downloads/5.json | tr -d '\n' | sed -E 's@.+"(https://.+?/([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+-[0-9a-f]{8,})/debian/plexmediaserver_\2_arm64\.deb)".+@\1@')
[[ -z "$DOWNLOAD_URL" ]] && echoe "Received empty download URL" && exit 1
PACKAGE_PATH=$(mktemp)
curl --output="$PACKAGE_PATH" -- "$DOWNLOAD_URL"
echoe "+ Installing plex"
sudo dpkg -i "$PACKAGE_PATH"
rm -- "$PACKAGE_PATH"

echoe "+ Miscellaneous setup"
sudo iptables -F
sudo mkdir -p /home/plex/{plexcloud,cache}
sudo chown -R plex:plex /home/plex
sudo sed -i -E 's/^#user_allow_other/user_allow_other/' /etc/fuse.conf

echoe "Connect to the server with \"-L 32400:localhost:32400\", e.g."
echoe "\"ssh -L 32400:localhost:32400 ubuntu@ip\". Then open"
echoe "http://localhost:32400/web on your local machine to finish setup"
