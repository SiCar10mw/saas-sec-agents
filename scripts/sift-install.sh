#!/usr/bin/env bash
set -euo pipefail

# SIFT native Ubuntu install bootstrap.
# Reference: https://www.sans.org/tools/sift-workstation

if [[ "$(id -u)" -ne 0 ]]; then
  echo "Run as root (use sudo)." >&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y --no-install-recommends \
  curl \
  git \
  jq \
  python3 \
  python3-pip \
  unzip \
  ca-certificates

# Install SIFT via CAST.
curl -fsSL https://github.com/teamdfir/sift-cli/releases/latest/download/sift-cli-linux-amd64 \
  -o /usr/local/bin/cast
chmod +x /usr/local/bin/cast

# Install SIFT stack.
cast install teamdfir/sift

echo "SIFT install complete. Reboot recommended before validation." 
