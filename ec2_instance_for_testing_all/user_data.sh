#!/bin/bash

sudo apt-get update
sudo apt-get install aptitude -y
sudo aptitude full-upgrade -y
sudo aptitude autoclean -y
sudo aptitude install git docker.io docker-compose-v2 -y
sudo systemctl enable --now docker
sudo usermod -aG docker ubuntu
sudo service docker restart
cd /home/ubuntu
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.31.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
cat << 'EOF' >> /home/ubuntu/.bashrc
alias kc="kubectl"
alias dc="docker compose"
EOF
sudo -u ubuntu git config --global user.email "devangmshr@gmail.com"
sudo -u ubuntu git config --global user.name "Devang Mishra"
sudo -u ubuntu git clone https://github.com/Dev00333/DevOps /home/ubuntu/DevOps
sudo chown -R ubuntu:ubuntu /home/ubuntu/DevOps
cd /home/ubuntu
ln -s /home/ubuntu/DevOps/KUBERNETES/LondeShubham k8s
rm /home/ubuntu/kubectl /home/ubuntu/kubectl.sha256
sudo reboot