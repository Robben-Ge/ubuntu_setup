#!/usr/bin/env bash

need_cmd wget
need_cmd bash

# Check if conda is already installed
if command -v conda &> /dev/null; then
  log "conda already installed: $(conda --version)"
  ok "conda installation skipped"
  exit 0
fi

# Check if conda directory exists
CONDA_DIR="$HOME/miniconda3"
if [[ -d "$CONDA_DIR" ]]; then
  log "Miniconda directory exists but conda command not found"
  log "Trying to initialize conda..."
  # Try to source conda.sh to make conda available
  if [[ -f "$CONDA_DIR/etc/profile.d/conda.sh" ]]; then
    source "$CONDA_DIR/etc/profile.d/conda.sh"
    if command -v conda &> /dev/null; then
      log "conda initialized successfully"
      ok "conda already installed"
      exit 0
    fi
  fi
fi

log "Installing Miniconda..."

# Download Miniconda installer
MINICONDA_INSTALLER="/tmp/miniconda_installer.sh"
MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"

log "Downloading Miniconda installer..."
wget -q "$MINICONDA_URL" -O "$MINICONDA_INSTALLER" || die "Failed to download Miniconda installer"

# Install Miniconda (non-interactive)
log "Installing Miniconda (this may take a while)..."
bash "$MINICONDA_INSTALLER" -b -p "$CONDA_DIR" || die "Failed to install Miniconda"

# Initialize conda for zsh
if [[ -f "$CONDA_DIR/etc/profile.d/conda.sh" ]]; then
  source "$CONDA_DIR/etc/profile.d/conda.sh"
  # Use conda init to generate proper initialization code
  log "Initializing conda for zsh..."
  conda init zsh --no-user-prefix || warn "Failed to initialize conda for zsh"
  # Disable auto-activate base (manual activation preferred)
  conda config --set auto_activate_base false || warn "Failed to configure conda"
  log "conda initialized successfully"
else
  warn "conda.sh not found, conda may need manual initialization"
fi

# Clean up installer
rm -f "$MINICONDA_INSTALLER"

ok "Miniconda installed successfully"

