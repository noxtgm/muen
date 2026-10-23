#!/bin/bash

_log_to_file() {
    { printf '[%(%Y-%m-%d %H:%M:%S)T] [%s] %s\n' -1 "$1" "$2" >> "${REPO_LOG:-/dev/null}"; } 2>/dev/null || true
}

log_step() {
    printf '\n%s==>%s %s%s%s\n' "$BLUE" "$OFF" "$BOLD" "$1" "$OFF"
    _log_to_file STEP "$1"
}

log_info() {
    printf '  %s->%s %s\n' "$GREEN" "$OFF" "$1"
    _log_to_file INFO "$1"
}

log_warn() {
    printf '%sWARNING:%s %s\n' "$YELLOW" "$OFF" "$1" >&2
    _log_to_file WARN "$1"
}

log_error() {
    printf '%sERROR:%s %s\n' "$RED" "$OFF" "$1" >&2
    _log_to_file ERROR "$1"
}

die() {
    log_error "$1"
    exit 1
}
