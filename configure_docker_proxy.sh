#!/usr/bin/env bash
# Standalone script to configure Docker daemon proxy
# Usage: ./configure_docker_proxy.sh [PROXY_HOST] [PROXY_PORT]
# Example: ./configure_docker_proxy.sh 127.0.0.1 7890

set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Load config if present
if [[ -f "$ROOT_DIR/config.env" ]]; then
  # shellcheck disable=SC1091
  source "$ROOT_DIR/config.env"
fi

# Load libs
# shellcheck disable=SC1091
source "$ROOT_DIR/lib/log.sh"
# shellcheck disable=SC1091
source "$ROOT_DIR/lib/ubuntu.sh"

need_cmd docker
need_cmd sudo

# Get proxy settings from arguments or environment
PROXY_HOST="${1:-${DOCKER_PROXY_HOST:-}}"
PROXY_PORT="${2:-${DOCKER_PROXY_PORT:-}}"

# Validate inputs
if [[ -z "$PROXY_HOST" ]] || [[ -z "$PROXY_PORT" ]]; then
  die "Usage: $0 [PROXY_HOST] [PROXY_PORT]
       Or set DOCKER_PROXY_HOST and DOCKER_PROXY_PORT in config.env
       Example: $0 127.0.0.1 7890"
fi

PROXY_URL="http://${PROXY_HOST}:${PROXY_PORT}"

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

# Wait a bit for Docker to start
sleep 2

# Verify configuration
if systemctl show --property=Environment docker | grep -q "HTTP_PROXY=${PROXY_URL}"; then
  ok "Docker proxy configured successfully"
  log "Proxy configuration:"
  systemctl show --property=Environment docker | grep -i proxy
else
  warn "Docker proxy configuration may not have taken effect"
  warn "Please check Docker service status: systemctl status docker"
fi

