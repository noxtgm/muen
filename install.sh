#!/bin/bash
set -euo pipefail

REPO_NAME="${REPO_NAME:-muen}"
REPO_AUTHOR="${REPO_AUTHOR:-noxtgm}"
REPO_BRANCH="${REPO_BRANCH:-main}"
REPO_URL="https://github.com/${REPO_AUTHOR}/${REPO_NAME}.git"
REPO_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/${REPO_NAME}"

SELF_DIR=""
if [[ -f "${BASH_SOURCE[0]:-}" ]]; then
    SELF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [[ -f "${SELF_DIR}/lib/init.sh" ]]; then
        REPO_PATH="$SELF_DIR"
    fi
fi

REPO_LOG="${XDG_STATE_HOME:-$HOME/.local/state}/${REPO_NAME}/${REPO_NAME}.log"
REPO_LIB="${REPO_PATH}/lib"

_clone_repo() {
    sudo pacman -Syu --noconfirm --needed git
    rm -rf "$REPO_PATH"
    git clone --branch "$REPO_BRANCH" "$REPO_URL" "$REPO_PATH"
}

_sudo_keepalive() {
    local keepalive_pid
    log_step "Requesting sudo privileges"
    sudo -v

    (
        set +e
        while kill -0 "$$" 2>/dev/null; do
            sudo -n -v
            sleep 60
        done
    ) &>/dev/null &
    keepalive_pid=$!
    trap "kill ${keepalive_pid} 2>/dev/null || true" EXIT

    log_info "Sudo granted and kept alive"
}

_install_all() {
    local reboot="$1"
    source "${REPO_LIB}/init.sh"
    mkdir -p "${REPO_LOG%/*}"

    log_step "Installing ${REPO_NAME} (${REPO_BRANCH}) from ${REPO_PATH}"

    _sudo_keepalive
    packages_install_pacman
    packages_install_yay
    packages_install_aur
    packages_install_npm
    links_apply

    log_step "Installation complete"
    if [[ "$reboot" == true ]]; then
        read -rt 10 -p "  Rebooting in 10s (Enter to reboot now, Ctrl+C to cancel) " || true
        sudo reboot
    fi
}

main() {
    local arg reboot=true
    for arg in "$@"; do
        case "$arg" in
            --no-reboot) reboot=false ;;
            *)
                printf '\e[1;31merror:\e[0m %s\n' "Unknown option: ${arg} (expected --no-reboot)" >&2
                exit 1
                ;;
        esac
    done

    if [[ "$REPO_PATH" == "$SELF_DIR" ]]; then
        _install_all "$reboot"
    else
        _clone_repo
        exec bash "${REPO_PATH}/install.sh" "$@" < /dev/tty
    fi
}

main "$@"
