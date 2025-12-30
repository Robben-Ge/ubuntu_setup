#!/usr/bin/env bash

apt_install \
  ca-certificates curl wget gnupg lsb-release \
  git openssh-client openssh-server \
  build-essential make cmake pkg-config \
  unzip zip tar \
  htop tree jq ripgrep fd-find \
  net-tools vim-gtk3 \
  gnome-shell-extension-manager

ok "base packages installed"
