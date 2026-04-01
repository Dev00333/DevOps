#!/bin/bash

sudo apt-get update
sudo apt full-upgrade -y
sudo apt-get install nginx -y
sudo start nginx
sudo systemctl enable nginx
echo "<h1>Nginx installed successfully</h1>" | sudo tee /var/www/html/index.html