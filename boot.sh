#!/bin/bash
set -euo pipefail

export REPO_AUTHOR="${REPO_AUTHOR:-noxtgm}"
export REPO_NAME="${REPO_NAME:-muen}"
export REPO_BRANCH="${REPO_BRANCH:-main}"
export REPO_URL="https://github.com/${REPO_AUTHOR}/${REPO_NAME}.git"
export REPO_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/${REPO_NAME}"
export REPO_LIB="${REPO_PATH}/lib"

export STATE_PATH="${XDG_STATE_HOME:-$HOME/.local/state}/${REPO_NAME}"
export LOG_FILE="${STATE_PATH}/${REPO_NAME}.log"

_boot_die() {
    printf '\e[1;31merror:\e[0m %s\n' "$1" >&2
    exit 1
}

_boot_step() {
    printf '\n\e[1;34m==>\e[0m \e[1m%s\e[0m\n' "$1"
}

_boot_clone() {
    if [[ -d "${REPO_PATH}/.git" ]]; then
        _boot_step "Updating ${REPO_PATH} (${REPO_BRANCH})"
        git -C "$REPO_PATH" fetch origin
        git -C "$REPO_PATH" checkout --force -B "$REPO_BRANCH" "origin/${REPO_BRANCH}"
    else
        _boot_step "Cloning ${REPO_URL} (${REPO_BRANCH})"
        rm -rf "$REPO_PATH"
        git clone --branch "$REPO_BRANCH" "$REPO_URL" "$REPO_PATH"
    fi
}

main() {
    [[ $EUID -ne 0 ]] || _boot_die "Run as a regular user, not root."
    [[ -f /etc/arch-release ]] || _boot_die "Only Arch Linux is supported."

    if ! command -v git &>/dev/null; then
        sudo pacman -S --noconfirm --needed git
    fi

    _boot_clone
    exec bash "${REPO_PATH}/install.sh" "$@" < /dev/tty
}

main "$@"
