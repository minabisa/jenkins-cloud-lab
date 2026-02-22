#!/bin/bash
set -e

# Ensure sshd runtime directory exists
mkdir -p /run/sshd

# Generate SSH host keys if missing (required for sshd)
if [ ! -f /etc/ssh/ssh_host_ed25519_key ]; then
  echo "Generating SSH host keys..."
  ssh-keygen -A
fi

# Generate Jenkins agent keypair (stored on host via volume)
if [ ! -f /sshkeys/jenkins_agent_key ]; then
  echo "Generating SSH keypair for Jenkins agent..."
  ssh-keygen -t ed25519 -f /sshkeys/jenkins_agent_key -N ""
fi

# Inject pubkey for jenkins user
export JENKINS_AGENT_SSH_PUBKEY="$(cat /sshkeys/jenkins_agent_key.pub)"

# If the image supports it, also write to authorized_keys directly (extra safety)
mkdir -p /home/jenkins/.ssh
chmod 700 /home/jenkins/.ssh
cat /sshkeys/jenkins_agent_key.pub > /home/jenkins/.ssh/authorized_keys
chmod 600 /home/jenkins/.ssh/authorized_keys
chown -R jenkins:jenkins /home/jenkins/.ssh || true

# Start sshd in foreground
exec /usr/sbin/sshd -D -e