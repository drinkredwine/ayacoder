#!/bin/bash
# This script creates a file that will modify /etc/hosts at container startup
# to ensure host.docker.internal is correctly mapped

# Create a script to add to the docker-entrypoint.d folder
cat << 'EOF' > custom-entrypoint.sh
#!/bin/sh
set -e

# Get Docker host IP
DOCKER_HOST_IP=$(ip route | grep default | awk '{print $3}')
if [ -z "$DOCKER_HOST_IP" ]; then
  DOCKER_HOST_IP="172.20.0.1"
fi

# Add host.docker.internal to /etc/hosts
echo "$DOCKER_HOST_IP host.docker.internal" >> /etc/hosts
echo "Added host.docker.internal ($DOCKER_HOST_IP) to /etc/hosts"

exec "$@"
EOF

# Make it executable
chmod +x custom-entrypoint.sh

echo "Created custom entrypoint script to map host.docker.internal"
echo "To use it, add the following to your docker-compose.yml:"
echo "  volumes:"
echo "    - ./custom-entrypoint.sh:/docker-entrypoint.d/99-host-mapping.sh:ro" 