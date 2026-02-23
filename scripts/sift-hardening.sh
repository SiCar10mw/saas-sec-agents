#!/usr/bin/env bash
set -euo pipefail

# Minimal hardening baseline for SIFT worker images.

if [[ "$(id -u)" -ne 0 ]]; then
  echo "Run as root (use sudo)." >&2
  exit 1
fi

# Disable password SSH auth.
sshd_config="/etc/ssh/sshd_config"
if grep -q '^#\?PasswordAuthentication' "$sshd_config"; then
  sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' "$sshd_config"
else
  echo 'PasswordAuthentication no' >> "$sshd_config"
fi

# Ensure root login is disabled.
if grep -q '^#\?PermitRootLogin' "$sshd_config"; then
  sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' "$sshd_config"
else
  echo 'PermitRootLogin no' >> "$sshd_config"
fi

systemctl restart ssh || systemctl restart sshd || true

# Basic OS patching.
apt-get update
apt-get -y upgrade
apt-get -y autoremove
apt-get clean

echo "Hardening complete. Validate SSH + patch levels before image capture."
