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

    sudo pacman -S --needed --noconfirm "${pkgs[@]}"
    log_info "${#pkgs[@]} packages installed"
}

packages_install_yay() {
    log_step "Installing yay"
    (
        build_dir="$(mktemp -d)"
        trap 'rm -rf "$build_dir"' EXIT
        git clone --depth 1 https://aur.archlinux.org/yay-bin.git "$build_dir"
        cd "$build_dir"
        makepkg -si --noconfirm
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

    npm install --global --prefix "$HOME/.local" "${pkgs[@]}"
    log_info "${#pkgs[@]} packages installed"
}
