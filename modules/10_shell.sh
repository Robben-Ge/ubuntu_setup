#!/usr/bin/env bash

apt_install zsh tmux fzf

# change default shell to zsh (idempotent)
ZSH_BIN="$(command -v zsh)"
CURRENT_SHELL="$(getent passwd "$USER" | cut -d: -f7)"

if [[ "$CURRENT_SHELL" != "$ZSH_BIN" ]]; then
  log "Current default shell: $CURRENT_SHELL"
  log "Changing default shell to zsh: $ZSH_BIN"
  warn "This may ask for your password"
  chsh -s "$ZSH_BIN" || warn "chsh failed (may need to run manually: chsh -s $(which zsh))"
  log "Default shell changed. Please log out and log back in for changes to take effect."
else
  log "Default shell is already zsh: $ZSH_BIN"
fi

# Install oh-my-zsh if not present
OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"
OH_MY_ZSH_SCRIPT="$OH_MY_ZSH_DIR/oh-my-zsh.sh"
if [[ ! -f "$OH_MY_ZSH_SCRIPT" ]]; then
  log "Installing oh-my-zsh"
  # Remove incomplete installation if directory exists but script is missing
  [[ -d "$OH_MY_ZSH_DIR" ]] && rm -rf "$OH_MY_ZSH_DIR"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || warn "oh-my-zsh installation failed"
fi

# Install zsh plugins
OH_MY_ZSH_PLUGINS_DIR="$OH_MY_ZSH_DIR/custom/plugins"
mkdir -p "$OH_MY_ZSH_PLUGINS_DIR"

# Install zsh-autosuggestions
AUTOSUGGESTIONS_DIR="$OH_MY_ZSH_PLUGINS_DIR/zsh-autosuggestions"
if [[ ! -d "$AUTOSUGGESTIONS_DIR" ]]; then
  log "Installing zsh-autosuggestions"
  git clone https://github.com/zsh-users/zsh-autosuggestions "$AUTOSUGGESTIONS_DIR" || warn "zsh-autosuggestions installation failed"
else
  log "zsh-autosuggestions already installed"
fi

# Install zsh-syntax-highlighting
SYNTAX_HIGHLIGHTING_DIR="$OH_MY_ZSH_PLUGINS_DIR/zsh-syntax-highlighting"
if [[ ! -d "$SYNTAX_HIGHLIGHTING_DIR" ]]; then
  log "Installing zsh-syntax-highlighting"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$SYNTAX_HIGHLIGHTING_DIR" || warn "zsh-syntax-highlighting installation failed"
else
  log "zsh-syntax-highlighting already installed"
fi

# Configure .zshrc
ZSHRC_FILE="$HOME/.zshrc"
# Get ROOT_DIR from parent script, or derive from script location
ROOT_DIR="${ROOT_DIR:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)}"
ZSHRC_TEMPLATE="$ROOT_DIR/templates/zshrc"

if [[ ! -f "$ZSHRC_TEMPLATE" ]]; then
  die "zshrc template not found: $ZSHRC_TEMPLATE"
fi

if [[ -f "$ZSHRC_FILE" ]]; then
  log "Backing up existing .zshrc to .zshrc.backup"
  cp "$ZSHRC_FILE" "$ZSHRC_FILE.backup"
fi

log "Configuring .zshrc"
cp "$ZSHRC_TEMPLATE" "$ZSHRC_FILE"

ok "shell tools installed"
