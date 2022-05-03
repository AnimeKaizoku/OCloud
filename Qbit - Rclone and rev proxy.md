0. Pre-commands
Open the damn ports and run:

```
sudo apt update && sudo apt upgrade -y && sudo iptables -F
```


1. Installing and setting up qBittorrent NOX	
	
```
sudo add-apt-repository -y ppa:qbittorrent-team/qbittorrent-stable && sudo apt install -y qbittorrent-nox && qbittorrent-nox --version && sudo vim /etc/systemd/system/qbittorrent-nox.service && sudo service qbittorrent-nox start && sudo systemctl enable qbittorrent-nox && sudo service qbittorrent-nox status
```


#---qBittorrent Service File---#
```
[Unit]
Description=qBittorrent NOX Service
After=network.target
 
[Service]
ExecStart=/usr/bin/qbittorrent-nox --webui-port=6969
Restart=always
 
[Install]
WantedBy=multi-user.target
```
#---qBittorrent Service File---#
	
	
2. Installing and setting up RClone Mount
	
```(curl https://rclone.org/install.sh | sudo bash) && rclone config && ((echo "mkdir /root/.config/ && mkdir /root/.config/rclone/ && cp /home/ubuntu/.config/rclone/rclone.conf /root/.config/rclone/. && exit") | sudo bash) && mkdir /home/ubuntu/qBit/ && mkdir /home/ubuntu/qBit/PT/ && sudo vim /etc/systemd/system/rclone-mount.service && sudo service rclone-mount start && sudo systemctl enable rclone-mount && sudo service rclone-mount status
```
	
#---RClone Mount Service File---#
```
[Unit]
Description=RClone Mount Service
Wants=network-online.target
After=network-online.target

[Service]
Type=notify
KillMode=none
Environment=GOMAXPROCS=2

ExecStart=rclone mount PrivateTrackers: /home/ubuntu/qBit/PT \
  --config /root/.config/rclone/rclone.conf \
  --use-mmap \
  --allow-other \
  --vfs-cache-mode minimal \
  --vfs-cache-max-age 48h \
  --read-only \
  --buffer-size 0  \
  --vfs-read-chunk-size 16M \
  --vfs-read-chunk-size-limit 0 \
  --vfs-read-ahead 0 \
  --no-modtime \
  --drive-pacer-min-sleep 10ms \

StandardOutput=file:/home/ubuntu/qBit/PT.log
ExecStop=/bin/fusermount -uz /home/ubuntu/qBit/PT
Restart=on-failure

[Install]
WantedBy=default.target
```
#---RClone Mount Service File---#
	
	
3. Installing and setting up Nginx

```
sudo apt install nginx -y && sudo systemctl start nginx && sudo vim /etc/nginx/sites-available/iroha.imyr.cf && sudo ln -s /etc/nginx/sites-available/iroha.imyr.cf /etc/nginx/sites-enabled/ && sudo rm /etc/nginx/sites-enabled/default && sudo systemctl restart nginx && sudo systemctl status nginx
```

#---Nginx Config File---#
```	
server {
        listen 80;
        server_name iroha.imyr.cf;

        location /qbt/ {
                        proxy_pass http://127.0.0.1:6969/;
                        proxy_set_header Host $host;
                        proxy_set_header X-Real-IP $remote_addr;
                        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }

        location /rbg/ {
                        proxy_pass http://rarbg.to/;
                        proxy_set_header Host $host;
                        proxy_set_header X-Real-IP $remote_addr;
                        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
}
```	
#---Nginx Config File---#

	
4. Installing and setting up Certbot and a SSL certificate

```
sudo apt install software-properties-common && sudo apt install certbot python3-certbot-nginx && sudo certbot --nginx --redirect --agree-tos --hsts --staple-ocsp --email notabstergo@gmail.com -d iroha.imyr.cf
```
