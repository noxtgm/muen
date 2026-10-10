#!/bin/bash

_log_to_file() {
    { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$1] $2" >> "${REPO_LOG:-/dev/null}"; } 2>/dev/null || true
}

log_step() {
    printf "\n${BLUE}==>${OFF} ${BOLD}%s${OFF}\n" "$1"
    _log_to_file STEP "$1"
}

log_info() {
    printf "  ${GREEN}->${OFF} %s\n" "$1"
    _log_to_file INFO "$1"
}

log_warn() {
    printf "${YELLOW}WARNING:${OFF} %s\n" "$1" >&2
    _log_to_file WARN "$1"
}

log_error() {
    printf "${RED}ERROR:${OFF} %s\n" "$1" >&2
    _log_to_file ERROR "$1"
}

die() {
    log_error "$1"
    exit 1
}
