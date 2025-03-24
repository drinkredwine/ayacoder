#!/bin/bash
# Fix Docker socket permissions for OpenHands

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Ensure docker group exists
if ! getent group docker > /dev/null; then
  echo "Creating docker group..."
  groupadd docker
fi

# Add current user to docker group
echo "Adding current user to docker group..."
usermod -aG docker $SUDO_USER

# Set appropriate permissions on Docker socket
echo "Setting permissions on Docker socket..."
chmod 666 /var/run/docker.sock

# Check SELinux status and adjust if needed
if command -v getenforce > /dev/null; then
  if [ "$(getenforce)" != "Disabled" ]; then
    echo "Configuring SELinux for Docker socket access..."
    semanage fcontext -a -t container_var_lib_t "/var/run/docker.sock"
    restorecon -v /var/run/docker.sock
  fi
fi

echo "Done! You may need to log out and back in for group changes to take effect."
echo "After that, restart OpenHands with: docker-compose down && docker-compose up -d" 