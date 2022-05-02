
```
sudo apt install xfce4 xfce4-goodies && sudo apt install tightvncserver && vncserver && vncpasswd && vncserver -kill :1 && mv ~/.vnc/xstartup ~/.vnc/xstartup.bak && sudo nano ~/.vnc/xstartup && chmod +x ~/.vnc/xstartup && vncserver -localhost && sudo nano /etc/systemd/system/vncserver@.service && sudo systemctl daemon-reload && sudo systemctl enable vncserver@1.service && vncserver -kill :1 && sudo systemctl start vncserver@1 && sudo systemctl status vncserver@1

```
First setup a pass for VNC 

Then nano will open, save this in nano 
```
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
```

Then nano will open again - save this

```
[Unit]
Description=Start TightVNC server at startup
After=syslog.target network.target

[Service]
Type=forking
User=ubuntu
Group=ubuntu
WorkingDirectory=/home/ubuntu

PIDFile=/home/ubuntu/.vnc/%H:%i.pid
ExecStartPre=-/usr/bin/vncserver -kill :%i > /dev/null 2>&1
ExecStart=/usr/bin/vncserver -depth 24 -geometry 1280x800 -localhost :%i
ExecStop=/usr/bin/vncserver -kill :%i

[Install]
WantedBy=multi-user.target
