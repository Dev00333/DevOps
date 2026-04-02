#!/bin/bash

sudo apt update && sudo apt full-upgrade -y
sudo apt install -y docker.io net-tools speedtest-cli docker-compose
# sudo systemctl start nginx
# sudo systemctl enable nginx
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
cd /home/ubuntu && wget https://nginx.org/download/nginx-1.29.7.tar.gz && tar -xzvf nginx-1.29.7.tar.gz