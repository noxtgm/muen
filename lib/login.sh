#!/bin/bash

# See https://man.sr.ht/~kennylevinsen/greetd/

LOGIN_GREETER_DIR="/etc/greetd/quickshell"

# Installs the greeter, the greeter user cannot read files in the user's home
_login_install_greeter() {
    local src="${REPO_PATH}/greeter/shell.qml" dest="${LOGIN_GREETER_DIR}/shell.qml"

    if sudo cmp -s "$src" "$dest"; then
        log_info "Greeter already up to date"
        return 0
    fi

    sudo install -Dm644 "$src" "$dest"
    log_info "Greeter installed"
}

_login_configure_greetd() {
    local file="/etc/greetd/config.toml" user content
    user="$(id -un)"
    content="$(cat <<EOF
[terminal]
vt = 1

# Shown after logging out or a crash
[default_session]
command = "cage -s -- env MUEN_USER=${user} qs -p ${LOGIN_GREETER_DIR}/shell.qml"
user = "greeter"

[initial_session]
command = "zsh -c 'exec start-hyprland -- --locked-cmd hyprlock'"
user = "${user}"
EOF
)"

    if printf '%s\n' "$content" | sudo cmp -s - "$file"; then
        log_info "greetd already up to date"
        return 0
    fi

    files_write_root "$file" "$content"
    log_info "greetd configured"
}

_login_enable_greetd() {
    if systemctl is-enabled --quiet greetd.service; then
        log_info "greetd already enabled"
        return 0
    fi

    sudo systemctl enable greetd.service
    log_info "greetd enabled, it takes over the login from the next boot"
}

login_configure() {
    log_step "Configuring login"
    _login_install_greeter
    _login_configure_greetd
    _login_enable_greetd
}
