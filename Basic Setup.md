
This copy paste does the following 

 - Update and Upgrade dependencies, remove whats not needed
 - Install Neofetch
 - Install Speedtest cli
 - Install golang and add it to `~/.profile` file
 - Install python-pip
 - Install fail2ban and enable it
 - Change the hostname to what you like and make it persistent
 - Install cloudflared for arm64
 - Edit neofetch config - (manual intervention needed here, comment out kernel, uncomment CPU and Disk)
 - Remove all the motd 
 - Install persistent iptables so that change via iptables -F are persistent
 
 
```sh
sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt install neofetch -y speedtest-cli python3-pip fail2ban iptables-persistent && neofetch && wget 'https://go.dev/dl/go1.18.1.linux-arm64.tar.gz' && sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.18.1.linux-arm64.tar.gz && echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile && rm 'go1.18.1.linux-arm64.tar.gz' -f && sudo systemctl enable fail2ban && sudo systemctl status fail2ban &&  sudo sed -i '/preserve_hostname: false/c\preserve_hostname: true' /etc/cloud/cloud.cfg && sudo hostnamectl set-hostname kinzokumaru.animekaizoku.com && wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64.deb && sudo dpkg -i cloudflared-linux-arm64.deb && sudo nano $HOME/.config/neofetch/config.conf && sudo chmod -x /etc/update-motd.d/* && sudo iptables-save > /etc/iptables/rules.v4 && sudo ip6tables-save > /etc/iptables/rules.v6
```

