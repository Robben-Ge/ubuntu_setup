#!/usr/bin/env bash
# Configure Docker APT repository using Aliyun mirror (阿里云).
# Run once before the first apt-get update when Docker repo is present, or to add Docker repo.
# Key and list format: https://mirrors.aliyun.com/docker-ce/linux/ubuntu/

fix_docker_apt_key_if_needed() {
  local docker_list="/etc/apt/sources.list.d/docker.list"
  local docker_sources="/etc/apt/sources.list.d/docker.sources"
  local keyring_dir="/etc/apt/keyrings"
  local keyring_file="${keyring_dir}/docker.gpg"
  local codename arch

  # Skip if neither Docker repo nor intent to add (e.g. no existing Docker source)
  if [[ ! -f "$docker_list" ]] && [[ ! -f "$docker_sources" ]]; then
    if ! grep -q -r "docker-ce\|download.docker.com" /etc/apt/sources.list /etc/apt/sources.list.d/ 2>/dev/null; then
      return 0
    fi
  fi

  if ! command -v curl >/dev/null 2>&1; then
    warn "Docker APT source detected but curl not found; cannot configure Docker key. Install curl or fix manually."
    return 0
  fi
  if ! command -v gpg >/dev/null 2>&1; then
    warn "gpg not found; cannot add Docker GPG key. Install gnupg or fix manually."
    return 0
  fi

  codename="$(lsb_release -cs 2>/dev/null)"
  if [[ -z "$codename" ]]; then
    codename="$(. /etc/os-release 2>/dev/null && echo "${VERSION_CODENAME:-$UBUNTU_CODENAME}")"
  fi
  if [[ -z "$codename" ]]; then
    warn "Could not detect Ubuntu codename; skipping Docker APT configuration"
    return 0
  fi
  arch="$(dpkg --print-architecture)"

  log "Configuring Docker APT repository (Aliyun mirror)..."

  sudo install -m 0755 -d "$keyring_dir"
  curl -fsSL "https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg" | sudo gpg --dearmor -o "$keyring_file"
  sudo chmod a+r "$keyring_file"

  echo "deb [arch=${arch} signed-by=${keyring_file}] https://mirrors.aliyun.com/docker-ce/linux/ubuntu ${codename} stable" | sudo tee "$docker_list" >/dev/null

  if [[ -f "$docker_sources" ]]; then
    log "Removing legacy Docker sources format: $docker_sources"
    sudo rm -f "$docker_sources"
  fi

  ok "Docker APT configured (Aliyun: signed-by ${keyring_file})"
}
