#!/bin/bash
set -euo pipefail

REPO_NAME="${REPO_NAME:-muen}"
REPO_AUTHOR="${REPO_AUTHOR:-noxtgm}"
REPO_BRANCH="${REPO_BRANCH:-main}"
REPO_URL="https://github.com/${REPO_AUTHOR}/${REPO_NAME}.git"
REPO_PATH="${REPO_PATH:-$HOME/.local/share/${REPO_NAME}}"

main() {
    if (( EUID == 0 )); then
        printf 'Run the installer as your user, not as root\n' >&2
        exit 1
    fi

    sudo pacman -Syu --needed --noconfirm git

    if [[ ! -d "${REPO_PATH}/.git" ]]; then
        git clone --branch "$REPO_BRANCH" "$REPO_URL" "$REPO_PATH"
    fi

    sudo ln -sf "${REPO_PATH}/bin/muen" /usr/local/bin/muen
    "${REPO_PATH}/bin/muen" update "$@"
}

main "$@"
