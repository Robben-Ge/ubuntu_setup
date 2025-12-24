#!/usr/bin/env bash

apt_install \
  ca-certificates curl wget gnupg lsb-release \
  git openssh-client \
  build-essential make cmake pkg-config \
  unzip zip tar \
  htop tree jq ripgrep fd-find

ok "base packages installed"
