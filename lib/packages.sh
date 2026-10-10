#!/bin/bash

_read_packages() {
    awk '{ for (i = 1; i <= NF; i++) print $i }' "$1"
}

packages_install_pacman() {
    local pkgs
    log_step "Installing pacman packages"
    mapfile -t pkgs < <(_read_packages "${REPO_PATH}/packages.pacman")
    if (( ${#pkgs[@]} == 0 )); then
        log_info "Nothing to install"
        return 0
    fi

    sudo pacman -Syu --needed --noconfirm "${pkgs[@]}"
    log_info "${#pkgs[@]} packages installed"
}

packages_install_yay() {
    log_step "Installing yay"
    if command -v yay > /dev/null; then
        log_info "yay already installed"
        return 0
    fi

    (
        build_dir="$(mktemp -d)"
        trap 'rm -rf "$build_dir"' EXIT
        git clone --depth 1 https://aur.archlinux.org/yay-bin.git "$build_dir"
        cd "$build_dir" || exit
        makepkg -sri --noconfirm
    )
    log_info "yay installed"
}

packages_install_aur() {
    local pkgs
    log_step "Installing AUR packages"
    mapfile -t pkgs < <(_read_packages "${REPO_PATH}/packages.aur")
    if (( ${#pkgs[@]} == 0 )); then
        log_info "Nothing to install"
        return 0
    fi

    yay -S --needed --noconfirm --answerclean None --answerdiff None "${pkgs[@]}"
    log_info "${#pkgs[@]} packages installed"
}

packages_install_npm() {
    local pkgs
    log_step "Installing npm packages"
    mapfile -t pkgs < <(_read_packages "${REPO_PATH}/packages.npm")
    if (( ${#pkgs[@]} == 0 )); then
        log_info "Nothing to install"
        return 0
    fi

    export PNPM_HOME="${PNPM_HOME:-$HOME/.local/share/pnpm}"
    export PATH="${PNPM_HOME}/bin:${PATH}"
    pnpm add --global "${pkgs[@]/#/--allow-build=}" "${pkgs[@]}"
    log_info "${#pkgs[@]} packages installed"
}
