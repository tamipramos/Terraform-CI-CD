#!/bin/bash
set -e

apt update -y
apt install -y docker.io docker-compose

systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu

mkdir -p /opt/frontend

cd /opt/frontend
docker-compose pull
docker-compose up -d
