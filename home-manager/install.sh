#!/usr/bin/env bash
set -euo pipefail

# Use sudo from nixpkgs (or system sudo)
SUDO="${SUDO:-/usr/bin/sudo}"

sudo pacman -S greetd-tuigreet --needed

# Create greeter user if missing
if ! id -u greeter &>/dev/null; then
  echo "Creating greeter user..."
  $SUDO useradd -m -s /bin/bash greeter
fi

# Copy greetd config
echo "Copying greetd config..."
$SUDO mkdir -p /etc/greetd
$SUDO cp ~/.config/greetd/config.toml /etc/greetd/config.toml
$SUDO chown root:root /etc/greetd/config.toml

# Enable greetd service
echo "Enabling greetd service..."
$SUDO systemctl enable greetd.service
$SUDO systemctl restart greetd.service
