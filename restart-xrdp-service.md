# Restarting xrdp service
After you have made changes to configuration stuff in xrdp, you will have to restart its service in order for those changes to take effect.
here are some ways of restarting it (I will add more commands related to this part when I find more)

<hr>

### first way:

```sh
sudo systemctl restart xrdp.service
```

### second way:

```sh
sudo /etc/init.d/xrdp restart
```


<hr/>

## xrdp service fails to restart, what to do?
There are multiple possibilities in this case:
- if you have edited configuration of xrdp in any way (such as editing your [xrdp.ini](https://linux.die.net/man/5/xrdp.ini) file), then most probably you have messed up its configuration, please take a look at this [file](fix-xrdp-config.md) for possible solutions on how to return back default settings.
