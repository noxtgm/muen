#!/bin/bash

# See https://wiki.archlinux.org/title/Silent_boot
BOOT_CMDLINE_PARAMS=(quiet loglevel=3 systemd.show_status=auto rd.udev.log_level=3)

# Hide the boot menu and stop boot options from being edited from it
BOOT_LOADER_OPTIONS=("timeout 0" "editor no")

BOOT_CMDLINE_FILE="/etc/kernel/cmdline"
BOOT_PRESET_FILE="/etc/mkinitcpio.d/linux.preset"

# Prints the command line with BOOT_CMDLINE_PARAMS added, replacing any other value for the same key
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

# Prints the preset without the Arch logo splash archinstall embeds in the boot image
_boot_preset() {
    printf '%s' "$1" | sed -E 's/^(default_options=".*)--splash[= ][^ "]*[[:space:]]*/\1/'
}

# Prints the boot loader configuration replacing an existing line for the same key
_boot_loader() {
    local content="$1" option key

    for option in "${BOOT_LOADER_OPTIONS[@]}"; do
        key="${option%% *}"
        if grep -q "^${key}\b" <<< "$content"; then
            content="$(sed -E "s/^${key}\b.*/${option}/" <<< "$content")"
        else
            content="${content:+${content}$'\n'}${option}"
        fi
    done

    printf '%s' "$content"
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

_boot_configure_loader() {
    local file loader_old loader_new
    file="$(sudo bootctl --print-esp-path)/loader/loader.conf"

    loader_old="$(sudo cat "$file")"
    loader_new="$(_boot_loader "$loader_old")"

    if [[ "$loader_new" == "$loader_old" ]]; then
        log_info "Boot menu already up to date"
        return 0
    fi

    files_write_root "$file" "$loader_new" ""
    log_info "Boot menu updated"
}

boot_configure() {
    log_step "Configuring boot"
    _boot_configure_images
    _boot_configure_loader
}
