0. Pre-commands
Open the damn ports (9117) and run:

```
sudo apt update && sudo apt upgrade -y && sudo iptables -F
```

1. Run jackett as service

```
wget https://github.com/Jackett/Jackett/releases/download/v0.20.1290/Jackett.Binaries.LinuxARM64.tar.gz (grab latest from https://github.com/Jackett/Jackett/releases) && tar -xvf Jackett.Binaries.LinuxARM64.tar.gz && chmod -R 777 Jackett && cd Jackett &&sudo ./install_service_systemd.sh
```
Note: Access Jackett through http://localhost:9117

2. Additional steps to setup flaresolverr for jackett

Docker need to be setup if not already

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

Flaresolverr

```
sudo docker run -d \
  --name=flaresolverr \
  -p 8191:8191 \
  -e LOG_LEVEL=info \
  --restart unless-stopped \
  ghcr.io/flaresolverr/flaresolverr:latest
 ```

Note: Configure FlareSolverr API URL in Jackett. For example: http://localhost:8191
