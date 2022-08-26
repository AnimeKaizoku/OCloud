0. Pre-commands
Open the port (9000) and run:

```
sudo apt update && sudo apt upgrade -y && sudo iptables -F
```

1. Installing Docker

#---Installing Docker---#

```
sudo apt-get update && sudo apt-get install ca-certificates curl gnupg lsb-release && sudo mkdir -p /etc/apt/keyrings && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```
```
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
``` 
```
sudo apt-get update && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
```
#---Installing Docker---#

2. Running TheLounge Docker

```
sudo docker run --detach \
             --name thelounge \
             --publish 9000:9000 \
             --volume ~/.thelounge:/var/opt/thelounge \
             --restart always \
             thelounge/thelounge:latest
```

Note: Lounge available at http://localhost:9000

3. How to setup a user for lounge

```
sudo docker ps
```
```
sudo docker exec -it containerId /bin/sh
```
```
thelounge add <name>
```

Note: For more detailed guide visit https://thelounge.chat/docs/users
