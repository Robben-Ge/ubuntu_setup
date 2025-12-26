#!/usr/bin/env bash
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

need_cmd bash
# Only check for sudo if not running as root
if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  need_cmd sudo
fi

assert_ubuntu
assert_not_root_but_sudo_ok

log "Ubuntu setup starting..."
apt_update_once

for f in "$ROOT_DIR"/modules/*.sh; do
  log "Running module: $(basename "$f")"
  # shellcheck disable=SC1090
  source "$f"
done

ok "All done."
