#!/bin/bash

_log_to_file() {
    [[ -n "${LOG_FILE:-}" ]] || return 0
    [[ -d "${LOG_FILE%/*}" ]] || mkdir -p "${LOG_FILE%/*}"
    printf '[%s] %-5s %s\n' "$(date '+%F %T')" "$1" "$2" >> "$LOG_FILE"
}

_log_on_error() {
    (( BASH_SUBSHELL == 0 )) || return 0
    log_error "'$2' failed with exit code $1 at ${3##*/}:$4"
}

log_trap_errors() {
    set -o errtrace
    trap '_log_on_error $? "$BASH_COMMAND" "${BASH_SOURCE[0]}" "$LINENO"' ERR
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
    printf "${YELLOW}warning:${OFF} %s\n" "$1" >&2
    _log_to_file WARN "$1"
}

log_error() {
    printf "${RED}error:${OFF} %s\n" "$1" >&2
    _log_to_file ERROR "$1"
}

die() {
    log_error "$1"
    exit 1
}
