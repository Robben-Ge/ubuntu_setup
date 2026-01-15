#!/usr/bin/env bash

# Configure pip to use Tsinghua mirror (for faster downloads in China)
PIP_CONFIG_DIR="$HOME/.pip"
PIP_CONFIG_FILE="$PIP_CONFIG_DIR/pip.conf"

log "Configuring pip to use Tsinghua mirror..."

# Create .pip directory if it doesn't exist
mkdir -p "$PIP_CONFIG_DIR"

# Create or update pip.conf
cat > "$PIP_CONFIG_FILE" << 'EOF'
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
trusted-host = pypi.tuna.tsinghua.edu.cn

[install]
trusted-host = pypi.tuna.tsinghua.edu.cn
EOF

log "pip configuration saved to: $PIP_CONFIG_FILE"

# Also configure pip3 if it exists
if command -v pip3 &> /dev/null; then
  log "pip3 found, configuration will also apply to pip3"
fi

# Also configure for root user if running with sudo (optional, may require password)
if command -v sudo &> /dev/null && sudo -n true >/dev/null 2>&1; then
  ROOT_PIP_CONFIG_DIR="/root/.pip"
  ROOT_PIP_CONFIG_FILE="$ROOT_PIP_CONFIG_DIR/pip.conf"
  log "Configuring pip for root user..."
  sudo mkdir -p "$ROOT_PIP_CONFIG_DIR"
  sudo tee "$ROOT_PIP_CONFIG_FILE" > /dev/null << 'EOF'
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
trusted-host = pypi.tuna.tsinghua.edu.cn

[install]
trusted-host = pypi.tuna.tsinghua.edu.cn
EOF
  log "pip configuration saved for root user"
else
  log "Skipping root user pip configuration (requires sudo password)"
fi

ok "pip configured to use Tsinghua mirror"
