_system_file_current() {
    sudo cmp -s -- "${REPO_PATH}/system/$1" "/$1"
}

_system_file_install() {
    sudo install -Dm 644 -- "${REPO_PATH}/system/$1" "/$1"
}

_system_configure_cmdline() {
    local file='etc/cmdline.d/quiet.conf'

    log_step 'Configuring the kernel command line'

    if _system_file_current "$file"; then
        log_info 'Kernel command line up to date'
    else
        _system_file_install "$file"
        log_info 'Kernel command line updated'
    fi
}

_system_configure_console() {
    local issue='/etc/issue.d/cursor.issue'
    local cursor

    log_step 'Restoring the cursor on text consoles'

    cursor="$(setterm --term linux --cursor on)"

    if cmp -s -- "$issue" <(printf '%s' "$cursor"); then
        log_info 'Text console cursor up to date'
    else
        printf '%s' "$cursor" | sudo install -Dm 644 -- /dev/stdin "$issue"
        log_info 'Text console cursor restored'
    fi
}

_system_configure_boot_loader() {
    local file='boot/loader/loader.conf'

    log_step 'Configuring the boot loader'

    if _system_file_current "$file"; then
        log_info 'Boot loader configuration up to date'
    else
        _system_file_install "$file"
        log_info 'Boot loader configuration updated'
    fi

    if systemctl is-enabled --quiet systemd-boot-update.service; then
        log_info 'Automatic boot loader updates already enabled'
    else
        sudo systemctl enable --quiet systemd-boot-update.service
        log_info 'Automatic boot loader updates enabled'
    fi
}

_system_configure_zram() {
    local sysctl='etc/sysctl.d/90-vm-zram-parameters.conf'
    local size='etc/systemd/zram-generator.conf.d/60-swap-size.conf'

    log_step 'Tuning swap on zram'

    if _system_file_current "$sysctl"; then
        log_info 'Memory settings up to date'
    else
        _system_file_install "$sysctl"
        log_info 'Memory settings updated'
    fi

    if _system_file_current "$size"; then
        log_info 'Swap size up to date'
    else
        _system_file_install "$size"
        log_info 'Swap size updated'
    fi
}

system_configure() {
    _system_configure_cmdline
    _system_configure_console
    _system_configure_boot_loader
    _system_configure_zram
}

system_rebuild_boot_images() {
    log_step 'Rebuilding the boot images'

    if ! sudo mkinitcpio -P; then
        die "Rebuilding the boot images failed, fix the error and run 'muen update' again"
    fi

    log_info 'Boot images rebuilt'
}
