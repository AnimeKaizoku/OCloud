# OCloud

A small repo with set of one run commands to set specific stuff on Ubuntu Env


These are done in serial order 

1. [Basic setup](https://github.com/AnimeKaizoku/OCloud/blob/main/Basic%20Setup.md)
2. [Setup VNC](https://github.com/AnimeKaizoku/OCloud/blob/main/VNC.md)
3. [Setup RDP](https://github.com/AnimeKaizoku/OCloud/blob/main/RDP.md)
4. [Switch xfce to gnome](https://github.com/AnimeKaizoku/OCloud/blob/main/gnome-session-with-xrdp.md) 


Stuff to do 
Make a single bash file that 

• Update and Upgrade dependencies, remove whats not needed
• Install Neofetch, neofetch, fail2ban and enable it
• Change the hostname to what you like and make it persistent
• Install cloudflared for arm64
• Edit neofetch config - (manual intervention needed here, comment out kernel, uncomment CPU and Disk)
• Remove all the motd
• Install persistent iptables so that change via iptables -F are persistent
• Setup VNC with xfce
• Setup RDP with gnome
