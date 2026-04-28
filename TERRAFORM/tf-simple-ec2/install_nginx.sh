#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
# this command prevents interactive commands from popping during updates when user is not present to press ok
sudo apt-get update
sudo apt-get full-upgrade -y
sudo apt-get install nginx docker.io docker-compose-v2 speedtest-cli -yq
sudo systemctl enable --now nginx
sudo systemctl enable --now docker
# this --now flag simultaneiously starts and enables the service
sudo usermod -aG docker ubuntu
sudo shutdown -r +1