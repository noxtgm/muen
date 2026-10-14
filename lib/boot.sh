#!/bin/bash

# See https://wiki.archlinux.org/title/Silent_boot
BOOT_CMDLINE_PARAMS=(quiet loglevel=3 systemd.show_status=auto rd.udev.log_level=3)

# Adds BOOT_CMDLINE_PARAMS to the unified kernel image command line replacing any other value for the same key
_boot_configure_cmdline() {
    local file="/etc/kernel/cmdline"
    local -a current=() updated=()
    local token param drop

    read -ra current < "$file"
    for token in "${current[@]}"; do
        drop=0
        for param in "${BOOT_CMDLINE_PARAMS[@]}"; do
            if [[ "$token" == "${param%%=*}" || "$token" == "${param%%=*}="* ]]; then
                drop=1
            fi
        done
        if (( ! drop )); then
            updated+=("$token")
        fi
    done
    updated+=("${BOOT_CMDLINE_PARAMS[@]}")

    if [[ "${current[*]}" == "${updated[*]}" ]]; then
        log_info "Kernel command line already up to date"
        return 0
    fi

    files_write_root "$file" "${updated[*]}"
    if ! sudo mkinitcpio -P; then
        files_write_root "$file" "${current[*]}"
        die "Failed to rebuild the boot images, kernel command line left unchanged"
    fi
    log_info "Kernel command line updated"
}

# Sets key value pair in the boot loader configuration, replacing an existing line for the same key
_boot_set_loader_option() {
    local file="$1" key="$2" value="$3"

    if sudo grep -qx "${key} ${value}" "$file"; then
        return 1
    fi

    if sudo grep -q "^${key}\b" "$file"; then
        sudo sed -i "s/^${key}\b.*/${key} ${value}/" "$file"
    else
        printf '%s %s\n' "$key" "$value" | sudo tee -a "$file" > /dev/null
    fi
}

# Hides the boot menu and stops boot options from being edited from it
_boot_configure_loader() {
    local file changed=0
    file="$(sudo bootctl --print-esp-path)/loader/loader.conf"

    if _boot_set_loader_option "$file" timeout 0; then
        changed=1
    fi
    if _boot_set_loader_option "$file" editor no; then
        changed=1
    fi

    if (( changed )); then
        log_info "Boot menu updated"
    else
        log_info "Boot menu already up to date"
    fi
}

boot_configure() {
    log_step "Configuring boot"
    _boot_configure_cmdline
    _boot_configure_loader
}
