#!/usr/bin/env bash

log() { printf "\033[1;34m[INFO]\033[0m %s\n" "$*"; }
ok()  { printf "\033[1;32m[ OK ]\033[0m %s\n" "$*"; }
warn(){ printf "\033[1;33m[WARN]\033[0m %s\n" "$*"; }
die() { printf "\033[1;31m[ERR ]\033[0m %s\n" "$*"; exit 1; }

need_cmd() { command -v "$1" >/dev/null 2>&1 || die "missing command: $1"; }
