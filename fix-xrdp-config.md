# xrdp config issue
sometimes happens you break things in xrdp configurations, at this point, you will encounter errors such as this:

![image](resources/Screenshot%20at%202022-05-02%2020-26-44.png)


at this point, you better just restore the original configuration files of xrdp by running following commands:
```sh
sudo mv /etc/xrdp/sesman.ini /etc/xrdp/sesman.ini.sav
sudo mv /etc/xrdp/startwm.sh /etc/xrdp/startwm.sh.sav
sudo mv /etc/xrdp/xrdp.ini /etc/xrdp/xrdp.ini.sav
sudo apt -o Dpkg::Options::="--force-confmiss" install --reinstall xrdp
```

> these commands are taken from [here](https://github.com/neutrinolabs/xrdp/issues/1614#issuecomment-648664516).

<hr/>

You will see the following output (or something similar to it):

![image](resources/Screenshot%20at%202022-05-02%2020-32-08.png)

> now xrdp is having default configuration it ever had- you have to start configuring it from zero. this time make sure you doesn't mess up its config stuff tho


Also, don't forget to restart the service after you are done doing configuration stuff:
```sh
sudo systemctl restart xrdp.service
```

![image](resources/Screenshot%20at%202022-05-02%2020-34-55.png)

^ You will see that service won't fail to be restarted.
