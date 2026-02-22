#!/bin/bash
set -euxo pipefail

apt-get update -y
apt-get install -y ca-certificates curl git docker.io

systemctl enable --now docker

# Install docker compose v2 binary if plugin isn't available
if ! docker compose version >/dev/null 2>&1; then
  curl -L "https://github.com/docker/compose/releases/download/v2.24.6/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
  ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
fi

mkdir -p /opt/jenkins-cloud-lab
cd /opt/jenkins-cloud-lab

if [ ! -d ".git" ]; then
  git clone -b "main" "https://github.com/minabisa/jenkins-cloud-lab.git" .
else
  git pull
fi

cd jenkins
mkdir -p ssh

docker compose up -d --build || docker-compose up -d --build
docker ps