#!/bin/bash

# Exit on error
set -e

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root"
    exit 1
fi

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check and install required packages
install_dependencies() {
    echo "Checking dependencies..."
    
    if ! command_exists docker; then
        echo "Installing Docker..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sh get-docker.sh
        rm get-docker.sh
    fi
    
    if ! command_exists docker-compose; then
        echo "Installing Docker Compose..."
        curl -L "https://github.com/docker/compose/releases/download/v2.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
    fi
    
    if ! command_exists htpasswd; then
        echo "Installing apache2-utils..."
        if command_exists apt-get; then
            apt-get update && apt-get install -y apache2-utils
        elif command_exists yum; then
            yum install -y httpd-tools
        fi
    fi
}

# Setup SSL certificates if they don't exist
setup_ssl() {
    if [ ! -f "ssl/nginx.crt" ] || [ ! -f "ssl/nginx.key" ]; then
        echo "Generating SSL certificates..."
        mkdir -p ssl
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -keyout ssl/nginx.key -out ssl/nginx.crt \
            -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"
    fi
}

# Setup authentication if not exists
setup_auth() {
    if [ ! -f "htpasswd" ]; then
        echo "Setting up authentication..."
        echo "Please enter username for authentication:"
        read username
        htpasswd -c htpasswd $username
    fi
}

# Main deployment function
deploy() {
    echo "Starting deployment..."
    
    # Install dependencies
    install_dependencies
    
    # Setup SSL and auth
    setup_ssl
    setup_auth
    
    # Stop existing containers
    echo "Stopping existing containers..."
    docker-compose down || true
    
    # Pull latest images
    echo "Pulling latest images..."
    docker-compose pull
    
    # Start containers
    echo "Starting containers..."
    docker-compose up -d
    
    echo "Deployment complete!"
    echo "You can check the status with: docker-compose ps"
    echo "View logs with: docker-compose logs -f"
}

# Run deployment
deploy 