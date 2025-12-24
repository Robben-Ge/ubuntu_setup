#!/usr/bin/env bash

apt_install zsh tmux fzf

# change default shell to zsh (idempotent)
ZSH_BIN="$(command -v zsh)"
if [[ "${SHELL:-}" != "$ZSH_BIN" ]]; then
  warn "Changing default shell to zsh (may ask password)"
  chsh -s "$ZSH_BIN" || warn "chsh failed (maybe not allowed here)"
fi

ok "shell tools installed"
