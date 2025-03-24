# ayacoder

We run openhands in docker on Hetzner Cloud with Nginx reverse proxy for security.

## Project Structure

```
.
├── docker-compose.yml    # Docker services configuration
├── nginx.conf           # Nginx reverse proxy configuration
├── deploy.sh           # Server deployment script
├── setup.sh           # Local development setup script
└── .gitignore         # Git ignore rules
```

## Prerequisites

1. Docker installed and user added to docker group
2. Docker Compose installed
3. apache2-utils (for htpasswd utility)

To install prerequisites on Ubuntu/Debian:
```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER  # Add your user to docker group
rm get-docker.sh

# Install Docker Compose
sudo apt-get update
sudo apt-get install -y docker-compose apache2-utils

# Log out and log back in for group changes to take effect
```

## Server Deployment

1. SSH into your Hetzner server:
```bash
ssh dodo@your-server-ip
```

2. Clone the repository:
```bash
cd ~
git clone https://github.com/drinkredwine/ayacoder.git
cd ayacoder
```

3. Run the deployment script:
```bash
./deploy.sh
```

The deployment script will:
- Check for required dependencies
- Set up SSL certificates if they don't exist
- Configure authentication if not already set up
- Deploy the services using Docker Compose

## Security

The setup includes:
- HTTPS encryption with self-signed certificates
- Basic authentication
- Reverse proxy to protect the OpenHands container
- No direct exposure of the OpenHands container to the internet
- Proper file permissions for sensitive files

## Maintenance

- To update the services:
```bash
git pull
./deploy.sh
```

- To view logs:
```bash
docker-compose logs -f
```

- To check service status:
```bash
docker-compose ps
```

- To check Nginx access logs:
```bash
docker-compose logs nginx
```

## Troubleshooting

1. If you can't connect to Docker:
```bash
# Check if your user is in the docker group
groups
# Should include 'docker' in the output

# If not, add your user and log out/in
sudo usermod -aG docker $USER
```

2. If SSL certificates need to be regenerated:
```bash
rm -rf ssl/
./deploy.sh
```

3. If you need to reset authentication:
```bash
rm htpasswd
./deploy.sh
```

## Original OpenHands Configuration

For reference, this is the original OpenHands Docker configuration that we've secured:

```bash
docker pull docker.all-hands.dev/all-hands-ai/runtime:0.29-nikolaik

docker run -it --rm --pull=always \
    -e SANDBOX_RUNTIME_CONTAINER_IMAGE=docker.all-hands.dev/all-hands-ai/runtime:0.29-nikolaik \
    -e LOG_ALL_EVENTS=true \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v ~/.openhands-state:/.openhands-state \
    -p 3000:3000 \
    --add-host host.docker.internal:host-gateway \
    --name openhands-app \
    docker.all-hands.dev/all-hands-ai/openhands:0.29
```

# security
All hands provide interface without authentication.
We need to secure the docker container.

# docker





