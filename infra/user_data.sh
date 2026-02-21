#!/bin/bash
set -e

apt-get update -y
apt-get install -y ca-certificates curl git

# Install Docker (Ubuntu repo docker.io is fine for lab)
apt-get install -y docker.io
systemctl enable --now docker

# Install docker compose plugin (Ubuntu may include it; if not, install)
apt-get install -y docker-compose-plugin || true

# App folder
mkdir -p /opt/jenkins-cloud-lab
cd /opt/jenkins-cloud-lab

# Clone your repo
if [ ! -d ".git" ]; then
  git clone -b "${github_branch}" "${github_repo}" .
else
  git pull
fi

# Start Jenkins + agent
cd jenkins
mkdir -p ssh
docker compose up -d --build