# gnome-session with xrdp
in total, xfce has a shitty UI (no offense, but that's the truth), so if you would like to use gnome-session instead of xfce-session, please read this file.

> warning: this file considers you are using default configuration of xrdp, if you have made changes to config files, please consider resetting them to default by following the steps in [this file](fix-xrdp-config.md).

<hr/>

## make sure you have ubuntu-desktop installed

use the following command:
```sh
sudo apt install ubuntu-desktop
```

what we expect, is the following output:

![image](resources/Screenshot%20at%202022-05-02%2021-06-43.png)

## install gnome-session

use the following command to install `gnome-session` and its dependencies:
```sh
sudo apt-get install gnome-session
```

Disable `newcursors` because black background around cursor is displayed if using Xorg as session type.

```sh
sudo sed -e 's/^new_cursors=true/new_cursors=false/g' \
           -i /etc/xrdp/xrdp.ini
```

then restart the xrdp
```sh
sudo systemctl restart xrdp
```

## Create ~/.xsessionrc
Create ~/.xsessionrc which will export the environment variable for customized settings for Ubuntu.

First do:
```sh
D=/usr/share/ubuntu:/usr/local/share:/usr/share:/var/lib/snapd/desktop
```
then:

```sh
cat <<EOF > ~/.xsessionrc
export GNOME_SHELL_SESSION_MODE=ubuntu
export XDG_CURRENT_DESKTOP=ubuntu:GNOME
export XDG_DATA_DIRS=${D}
export XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg
EOF
```

## reboot the system
I'm not sure if this is required or not, but it this method didn't work for me without rebooting the system.
```sh
sudo reboot
```

now login to the host again and try to restart xrdp:
```sh
sudo systemctl restart xrdp
```
(you shouldn't get any error or output from this command, if you are getting any, it means you have done something wrong in the middle, please go back and check stuff).

## All done
now configure the rdp client you are using to connect to the host

set up these configuration the way you want and hit next button:
![image](resources/Screenshot%20at%202022-05-02%2020-54-49.png)

![image](resources/Screenshot%20at%202022-05-02%2020-55-48.png)

![image](resources/Screenshot%20at%202022-05-02%2020-56-08.png)

![image](resources/Screenshot%20at%202022-05-02%2020-56-24.png)


