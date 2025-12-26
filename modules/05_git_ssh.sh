#!/usr/bin/env bash

need_cmd git
need_cmd ssh-keygen
need_cmd ssh-agent
need_cmd ssh-add

# ---------- Git basic config ----------
if [[ -n "${GIT_NAME:-}" ]]; then
  git config --global user.name "$GIT_NAME"
else
  warn "GIT_NAME not set; skip git user.name"
fi

if [[ -n "${GIT_EMAIL:-}" ]]; then
  git config --global user.email "$GIT_EMAIL"
else
  warn "GIT_EMAIL not set; skip git user.email"
fi

git config --global init.defaultBranch main
git config --global pull.rebase false

ok "git config done"

# ---------- SSH key generation ----------
SSH_DIR="$HOME/.ssh"
SSH_KEY_PATH="${SSH_KEY_PATH:-$HOME/.ssh/id_ed25519}"
SSH_KEY_TYPE="${SSH_KEY_TYPE:-ed25519}"
SSH_KEY_PASSPHRASE="${SSH_KEY_PASSPHRASE-}"

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

if [[ -f "$SSH_KEY_PATH" ]]; then
  ok "SSH key already exists: $SSH_KEY_PATH"
  log "Displaying existing public key:"
  echo "--------------------------------------------------"
  cat "$SSH_KEY_PATH.pub"
  echo "--------------------------------------------------"
else
  log "Generating SSH key: type=$SSH_KEY_TYPE path=$SSH_KEY_PATH"

  # comment: prefer email, fallback to user@host
  COMMENT="${GIT_EMAIL:-$(whoami)@$(hostname)}"

  if [[ -z "${SSH_KEY_PASSPHRASE+x}" ]]; then
    # variable not set: let ssh-keygen prompt
    ssh-keygen -t "$SSH_KEY_TYPE" -f "$SSH_KEY_PATH" -C "$COMMENT"
  else
    # variable set (possibly empty): non-interactive
    ssh-keygen -t "$SSH_KEY_TYPE" -f "$SSH_KEY_PATH" -C "$COMMENT" -N "$SSH_KEY_PASSPHRASE"
  fi

  chmod 600 "$SSH_KEY_PATH"
  chmod 644 "$SSH_KEY_PATH.pub"

  ok "SSH key generated"
fi

# ---------- ssh-agent ----------
# Start agent if not running for current user
CURRENT_USER="${USER:-$(id -un)}"
if ! pgrep -u "$CURRENT_USER" ssh-agent >/dev/null 2>&1; then
  log "Starting ssh-agent"
  eval "$(ssh-agent -s)" >/dev/null
fi

# Add key (may prompt for passphrase if set)
ssh-add "$SSH_KEY_PATH" >/dev/null 2>&1 || warn "ssh-add failed (maybe needs passphrase or agent env missing)"

ok "ssh-agent ready"

# ---------- print pub key ----------
log "Public key (copy to GitHub/GitLab):"
echo "--------------------------------------------------"
cat "$SSH_KEY_PATH.pub"
echo "--------------------------------------------------"

log "Quick test (run manually): ssh -T git@github.com"
