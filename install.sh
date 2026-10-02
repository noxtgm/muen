#!/bin/bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/lib/init.sh"
log_trap_errors

_install_base() {
    log_step "Updating system"
    sudo pacman -Syu --needed --noconfirm base-devel git
}

_install_reboot() {
    local seconds=10
    log_step "Installation complete"
    while (( seconds > 0 )); do
        printf "\r  Rebooting in %2ds (Ctrl+C to cancel)" "$seconds"
        sleep 1
        seconds=$((seconds - 1))
    done
    printf "\n"
    sudo reboot
}

log_step "Installing ${REPO_NAME} (${REPO_BRANCH}) from ${REPO_PATH}"

preflight_checks
sudo_init
_install_base
packages_install_pacman
packages_install_yay
packages_install_aur
packages_install_npm
links_apply

if [[ "${1:-}" == "--no-reboot" ]]; then
    log_step "Installation complete"
else
    _install_reboot
fi
