#!/bin/bash
set -e

apt update -y
apt install -y docker.io docker-compose

systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu

mkdir -p /opt/backend
mkdir -p /opt/database

cd /opt/backend
docker-compose pull
docker-compose up -d

cd /opt/database
docker-compose pull
docker-compose up -d
