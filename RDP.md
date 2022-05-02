https://www.tecmint.com/install-xrdp-on-ubuntu/

```
sudo apt install ubuntu-desktop && sudo apt install xrdp && sudo systemctl status xrdp && sudo adduser ubuntu ssl-cert
```
Black screen fix 
```
sudo nano /etc/xrdp/startwm.sh
```

Add these lines just before the lines that test & execute Xsession as shown in the screenshot below.
```
unset DBUS_SESSION_BUS_ADDRESS
unset XDG_RUNTIME_DIR
```

```
sudo nano /etc/xrdp/startwm.sh
```
In this file, replace the lines

```
test -x /etc/X11/Xsession && exec /etc/X11/Xsession
exec /bin/sh /etc/X11/Xsession
```
with `startxfce4`

```sudo systemctl restart xrdp```


Run a reverse tunnel on cloudflared 
```
cloudflared access ssh --hostname rdp-benihime.kaizoku.cyou --url localhost:6665

```
