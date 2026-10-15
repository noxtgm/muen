#!/bin/bash

# See https://wiki.archlinux.org/title/Silent_boot
BOOT_CMDLINE_PARAMS=(quiet loglevel=3 systemd.show_status=auto rd.udev.log_level=3)

BOOT_CMDLINE_FILE="/etc/kernel/cmdline"
BOOT_PRESET_FILE="/etc/mkinitcpio.d/linux.preset"

_boot_cmdline() {
    local -a current=() updated=()
    local token param drop

    # mkinitcpio accepts parameters spread over several lines
    read -ra current <<< "${1//$'\n'/ }"
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

    printf '%s' "${updated[*]}"
}

_boot_preset() {
    printf '%s' "$1" | sed -E 's/^(default_options=".*)--splash[= ][^ "]*[[:space:]]*/\1/'
}

# Updates the kernel command line and the preset then rebuilds the boot images once if either changed
_boot_configure_images() {
    local cmdline_old cmdline_new preset_old preset_new

    cmdline_old="$(sudo cat "$BOOT_CMDLINE_FILE")"
    # Without the root and disk unlock parameters the rebuilt boot image would not boot
    if [[ -z "${cmdline_old//[[:space:]]/}" ]]; then
        die "${BOOT_CMDLINE_FILE} is empty, refusing to rebuild the boot images"
    fi
    preset_old="$(sudo cat "$BOOT_PRESET_FILE")"
    cmdline_new="$(_boot_cmdline "$cmdline_old")"
    preset_new="$(_boot_preset "$preset_old")"

    if [[ "$cmdline_new" == "$cmdline_old" && "$preset_new" == "$preset_old" ]]; then
        log_info "Boot images already up to date"
        return 0
    fi

    files_write_root "$BOOT_CMDLINE_FILE" "$cmdline_new"
    files_write_root "$BOOT_PRESET_FILE" "$preset_new"
    # Rebuild the boot images with the new settings restoring the old ones if that fails
    if ! sudo mkinitcpio -P; then
        files_write_root "$BOOT_CMDLINE_FILE" "$cmdline_old"
        files_write_root "$BOOT_PRESET_FILE" "$preset_old"
        die "Failed to rebuild the boot images, boot settings left unchanged"
    fi
    log_info "Boot images updated"
}

# Sets key value pair in the boot loader configuration replacing an existing line for the same key
_boot_set_loader_option() {
    local file="$1" key="$2" value="$3"

    if sudo grep -qx "${key} ${value}" "$file"; then
        return 1
    fi

    if sudo grep -q "^${key}\b" "$file"; then
        sudo sed -i "s/^${key}\b.*/${key} ${value}/" "$file" \
            || die "Failed to set ${key} in ${file}"
    else
        printf '%s %s\n' "$key" "$value" | sudo tee -a "$file" > /dev/null \
            || die "Failed to set ${key} in ${file}"
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
    _boot_configure_images
    _boot_configure_loader
}
