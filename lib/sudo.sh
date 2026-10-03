#!/bin/bash

_SUDO_KEEPALIVE_PID=""

_sudo_stop_keepalive() {
    if [[ -n "$_SUDO_KEEPALIVE_PID" ]]; then
        kill "$_SUDO_KEEPALIVE_PID" 2> /dev/null || true
    fi
}

sudo_init() {
    log_step "Requesting sudo privileges"
    sudo -v || die "Could not obtain sudo privileges, is $(id -un) in the wheel group?"

    (
        trap - ERR
        set +e
        while kill -0 "$$" 2> /dev/null; do
            sudo -n -v
            sleep 60
        done
    ) &> /dev/null &
    _SUDO_KEEPALIVE_PID=$!
    trap _sudo_stop_keepalive EXIT

    log_info "Sudo granted and kept alive"
}
