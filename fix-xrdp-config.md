# xrdp config issue
sometimes happens sometimes you break things in xrdp configurations, at this point, you will encounter errors such as this:

![image](resources/Screenshot%20at%202022-05-02%2020-26-44.png)


at this point, you better just restore the original configuration files of xrdp by running following commands:
```sh
sudo mv /etc/xrdp/sesman.ini /etc/xrdp/sesman.ini.sav
sudo mv /etc/xrdp/startwm.sh /etc/xrdp/startwm.sh.sav
sudo mv /etc/xrdp/xrdp.ini /etc/xrdp/xrdp.ini.sav
sudo apt -o Dpkg::Options::="--force-confmiss" install --reinstall xrdp
```

> these commands are taken from [here](https://github.com/neutrinolabs/xrdp/issues/1614#issuecomment-648664516).
