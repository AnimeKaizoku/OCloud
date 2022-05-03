
This copy paste does the following 

 • Update and Upgrade dependencies, remove whats not needed

 • Install Neofetch

 • Install Speedtest cli
 • Install fail2ban and enable it
 • Change the hostname to what you like and make it persistent
 • Install cloudflared for arm64
 • Edit neofetch config - (manual intervention needed here, comment out kernel, uncomment CPU and Disk)
 • Remove all the motd 
 • Install persistent iptables so that change via iptables -F are persistent
 
```
sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt install neofetch -y && neofetch && sudo apt install speedtest-cli -y && sudo apt install fail2ban -y && sudo systemctl enable fail2ban && sudo systemctl status fail2ban &&  sudo sed -i '/preserve_hostname: false/c\preserve_hostname: true' /etc/cloud/cloud.cfg && sudo hostnamectl set-hostname kinzokumaru.animekaizoku.com && wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64.deb && sudo dpkg -i cloudflared-linux-arm64.deb && sudo nano $HOME/.config/neofetch/config.conf && sudo chmod -x /etc/update-motd.d/* && sudo apt-get install iptables-persistent -y && sudo iptables-save > /etc/iptables/rules.v4 && sudo ip6tables-save > /etc/iptables/rules.v6
```

