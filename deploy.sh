#!/bin/bash

# Exit on error
set -e

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check and install required packages
install_dependencies() {
    echo "Checking dependencies..."
    
    if ! command_exists docker; then
        echo "Error: Docker is not installed. Please install Docker and add your user to the docker group."
        exit 1
    fi
    
    if ! command_exists docker-compose; then
        echo "Error: Docker Compose is not installed. Please install Docker Compose."
        exit 1
    fi
    
    if ! command_exists htpasswd; then
        echo "Error: apache2-utils is not installed. Please install it to use htpasswd."
        echo "You can install it with:"
        echo "  Ubuntu/Debian: sudo apt-get install apache2-utils"
        echo "  CentOS/RHEL: sudo yum install httpd-tools"
        exit 1
    fi
    
    # Verify docker access
    if ! docker ps > /dev/null 2>&1; then
        echo "Error: Cannot access Docker. Make sure your user is in the docker group."
        echo "You can add your user to the docker group with:"
        echo "  sudo usermod -aG docker $USER"
        echo "Then log out and log back in."
        exit 1
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
        
        # Set appropriate permissions
        chmod 600 ssl/nginx.key
        chmod 644 ssl/nginx.crt
    fi
}

# Setup authentication if not exists
setup_auth() {
    if [ ! -f "htpasswd" ]; then
        echo "Setting up authentication..."
        echo "Please enter username for authentication:"
        read username
        htpasswd -c htpasswd $username
        chmod 600 htpasswd
    fi
}

# Main deployment function
deploy() {
    echo "Starting deployment..."
    
    # Check dependencies
    install_dependencies
    
    # Setup SSL and auth
    setup_ssl
    setup_auth
    
    # Create OpenHands state directory if it doesn't exist
    mkdir -p ~/.openhands-state
    
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
    echo "Your service should be available at: https://$(hostname -f)"
}

# Run deployment
deploy 