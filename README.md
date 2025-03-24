# ayacoder

We run openhands in docker on Hetzner Cloud.

Hostname: ayacoder

## Project Structure

```
.
├── docker-compose.yml    # Docker services configuration
├── nginx.conf           # Nginx reverse proxy configuration
├── deploy.sh           # Server deployment script
├── setup.sh           # Local development setup script
└── .gitignore         # Git ignore rules
```

## Local Development Setup

1. Clone the repository:
```bash
git clone <your-repo-url>
cd ayacoder
```

2. Run the setup script:
```bash
./setup.sh
```

3. Start the services locally:
```bash
docker-compose up -d
```

## Server Deployment

1. SSH into your Hetzner server:
```bash
ssh root@your-server-ip
```

2. Clone the repository:
```bash
git clone <your-repo-url>
cd ayacoder
```

3. Run the deployment script:
```bash
sudo ./deploy.sh
```

The deployment script will:
- Install required dependencies (Docker, Docker Compose, etc.)
- Set up SSL certificates if they don't exist
- Configure authentication if not already set up
- Deploy the services using Docker Compose

## Security

The setup includes:
- HTTPS encryption
- Basic authentication
- Reverse proxy to protect the OpenHands container
- No direct exposure of the OpenHands container to the internet

## Maintenance

- To update the services:
```bash
git pull
sudo ./deploy.sh
```

- To view logs:
```bash
docker-compose logs -f
```

- To check service status:
```bash
docker-compose ps
```

## Original OpenHands Configuration

The easiest way to run OpenHands is in Docker. See the Running OpenHands guide for system requirements and more information.

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



# security
All hands provide interface without authentication.
We need to secure the docker container.

# docker





