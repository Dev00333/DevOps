#!/bin/bash

sudo apt-get update
sudo apt full-upgrade -y
sudo apt install -y nginx docker.io docker-compose-v2
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu
sudo chown -R ubuntu:ubuntu /home/ubuntu
sudo reboot