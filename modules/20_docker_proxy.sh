#!/usr/bin/env bash

# Docker proxy configuration
# Requires: DOCKER_PROXY_HOST and DOCKER_PROXY_PORT in config.env
# Example: DOCKER_PROXY_HOST=127.0.0.1 DOCKER_PROXY_PORT=7890

need_cmd docker
need_cmd sudo

# Check if proxy is configured
if [[ -z "${DOCKER_PROXY_HOST:-}" ]] || [[ -z "${DOCKER_PROXY_PORT:-}" ]]; then
  warn "DOCKER_PROXY_HOST or DOCKER_PROXY_PORT not set, skipping Docker proxy configuration"
  warn "Set DOCKER_PROXY_HOST and DOCKER_PROXY_PORT in config.env to enable"
  return 0
fi

PROXY_URL="http://${DOCKER_PROXY_HOST}:${DOCKER_PROXY_PORT}"

log "Configuring Docker daemon proxy: $PROXY_URL"

# Create systemd override directory
sudo mkdir -p /etc/systemd/system/docker.service.d

# Create proxy configuration
sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf > /dev/null <<EOF
[Service]
Environment="HTTP_PROXY=${PROXY_URL}"
Environment="HTTPS_PROXY=${PROXY_URL}"
Environment="NO_PROXY=localhost,127.0.0.1,docker-registry.somecorporation.com"
EOF

# Reload systemd and restart Docker
log "Reloading systemd daemon..."
sudo systemctl daemon-reload

log "Restarting Docker service..."
sudo systemctl restart docker

# Verify configuration
if systemctl show --property=Environment docker | grep -q "HTTP_PROXY=${PROXY_URL}"; then
  ok "Docker proxy configured successfully"
else
  warn "Docker proxy configuration may not have taken effect"
fi

