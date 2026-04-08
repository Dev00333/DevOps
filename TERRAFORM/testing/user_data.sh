#!/bin/bash

exec > /var/log/user-data.log 2>&1

export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get full-upgrade -y \
  -o Dpkg::Options::="--force-confdef" \
  -o Dpkg::Options::="--force-confold"
apt-get install -y nginx docker.io docker-compose-v2 speedtest-cli git

usermod -aG docker ubuntu

echo 'newgrp docker' >> /home/ubuntu/.bashrc

systemctl enable nginx
systemctl start nginx
systemctl enable docker
systemctl start docker

# Wait for Docker daemon to be ready
while ! docker info > /dev/null 2>&1; do
  echo "Waiting for Docker..."
  sleep 2
done

sudo -u ubuntu GIT_TERMINAL_PROMPT=0 git clone https://github.com/Dev00333/bmi-calculator.git /home/ubuntu/bmi-calculator

sudo -u ubuntu sg docker -c "cd /home/ubuntu/bmi-calculator && docker compose up -d"

echo "User data script completed successfully"