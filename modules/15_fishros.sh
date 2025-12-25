#!/usr/bin/env bash

need_cmd wget
need_cmd bash

log "Installing fishros..."
log "Note: You can run this script multiple times to select different options"

# Download and run fishros installer directly
# fishros is an interactive auto-install script that handles everything
# This can be run multiple times to install different components
wget --no-check-certificate https://fishros.com/install -O fishros && bash fishros

ok "fishros installation completed"

