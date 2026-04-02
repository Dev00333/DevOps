#!/bin/bash

sudo apt update
sudo apt install -y nginx docker.io
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl start docker
sudo systemctl enable docker
sudo apt install -y docker-compose
sudo usermod -aG docker $USER
sudo apt full-upgrade -y
echo "Nginx and Docker have been installed and started successfully."