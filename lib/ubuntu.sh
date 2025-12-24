#!/usr/bin/env bash
APT_UPDATED=0

assert_ubuntu() {
  [[ -r /etc/os-release ]] || die "/etc/os-release not found"
  # shellcheck disable=SC1091
  source /etc/os-release
  [[ "${ID:-}" == "ubuntu" ]] || die "Ubuntu only. Detected: ${ID:-unknown}"
}

assert_not_root_but_sudo_ok() {
  if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
    die "Please run as a normal user with sudo, not root."
  fi
  # allow first-time sudo password prompt later
  sudo -n true >/dev/null 2>&1 || true
}

apt_update_once() {
  if [[ "$APT_UPDATED" -eq 0 ]]; then
    sudo apt-get update -y
    APT_UPDATED=1
  fi
}

apt_install() {
  apt_update_once
  sudo apt-get install -y --no-install-recommends "$@"
}
