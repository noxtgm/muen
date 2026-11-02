#!/bin/bash
set -euo pipefail

REPO_NAME="${REPO_NAME:-muen}"
REPO_AUTHOR="${REPO_AUTHOR:-noxtgm}"
REPO_BRANCH="${REPO_BRANCH:-main}"
REPO_URL="https://github.com/${REPO_AUTHOR}/${REPO_NAME}.git"
REPO_PATH="${REPO_PATH:-${XDG_DATA_HOME:-${HOME}/.local/share}/${REPO_NAME}}"

main() {
    if (( EUID == 0 )); then
        printf 'Run the installer as your regular user, not as root\n' >&2
        exit 1
    fi

    sudo pacman -Syu --needed --noconfirm git

    if [[ ! -d "${REPO_PATH}/.git" ]]; then
        git clone --branch "$REPO_BRANCH" "$REPO_URL" "$REPO_PATH"
    fi

    mkdir -p "${HOME}/.local/bin"
    ln -sf "${REPO_PATH}/bin/muen" "${HOME}/.local/bin/muen"
    "${REPO_PATH}/bin/muen" update "$@"
}

main "$@"
