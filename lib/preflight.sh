#!/bin/bash

_preflight_not_root() {
    [[ $EUID -ne 0 ]] || die "Run as a regular user, not root."
}

_preflight_arch() {
    [[ -f /etc/arch-release ]] || die "Only Arch Linux is supported."
}

_preflight_sudo() {
    command -v sudo &> /dev/null || die "sudo is not installed."
}

_preflight_network() {
    curl -fsS --max-time 10 -o /dev/null https://archlinux.org || die "No network connection (archlinux.org unreachable)."
}

preflight_checks() {
    log_step "Running preflight checks"
    _preflight_not_root
    _preflight_arch
    _preflight_sudo
    _preflight_network
    log_info "System ready"
}
