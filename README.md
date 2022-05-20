# OCloud

A small repo with set of one run commands to set specific stuff on Ubuntu Env

```
Usage: ./setup.sh [--basic=<new hostname>] [--de=xfce|gnome|kde] [--vnc +=[de]] [--rdp=[de]]
Options:
    -b, --basic: Run basic setup
    -d, --de: Set default DE for VNC and RDP (default: gnome)
    -v, --vnc: Run VNC setup (interaction needed for password if not set)
    -r, --rdp: Run RDP setup
```

Examples: 

Setup basic ubuntu base + vnc + rdp with gnome environment
```
wget https://raw.githubusercontent.com/AnimeKaizoku/OCloud/main/setup.sh && bash setup.sh --basic=senbonzakura --de=gnome --vnc=gnome --rdp=gnome
```


These are done in serial order 

1. [Basic setup](https://github.com/AnimeKaizoku/OCloud/blob/main/Basic%20Setup.md)
2. [Setup VNC](https://github.com/AnimeKaizoku/OCloud/blob/main/VNC.md)
3. [Setup RDP](https://github.com/AnimeKaizoku/OCloud/blob/main/RDP.md)
4. [Switch xfce to gnome](https://github.com/AnimeKaizoku/OCloud/blob/main/gnome-session-with-xrdp.md) 
