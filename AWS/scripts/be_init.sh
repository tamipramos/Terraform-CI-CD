#!/bin/bash
# Update OS
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Docker & Docker Compose
sudo apt-get install -y docker.io
sudo curl -L "https://github.com/docker/compose/releases/download/v2.18.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Add ubuntu to docker group
sudo usermod -aG docker ubuntu

# Create app folder and run docker-compose
mkdir -p /home/ubuntu/app
cd /home/ubuntu/app
docker compose pull
docker compose up -d --remove-orphans
