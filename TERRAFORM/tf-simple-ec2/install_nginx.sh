#!/bin/bash

sudo apt-get update
sudo apt full-upgrade -y
sudo apt-get install nginx docker.io docker-compose-v2 speedtest-cli -y
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl start docker
sudo systemctl enable docker
sudo adduser ubuntu docker