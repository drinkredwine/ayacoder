#!/bin/bash

# Create directories for SSL and configuration
mkdir -p ssl

# Generate self-signed SSL certificate (replace with Let's Encrypt in production)
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout ssl/nginx.key -out ssl/nginx.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

# Create .htpasswd file for authentication
echo "Please enter username for authentication:"
read username
htpasswd -c htpasswd $username

echo "Setup complete! You can now run: docker-compose up -d" 