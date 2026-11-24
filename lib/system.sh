_file_current() {
    sudo cmp -s -- "${REPO_PATH}/root/$1" "/$1"
}

_file_install() {
    sudo install -Dm 644 -- "${REPO_PATH}/root/$1" "/$1"
}

_configure_cmdline() {
    local quiet='etc/cmdline.d/quiet.conf'

    log_step 'Configuring the kernel command line'

    if _file_current "$quiet"; then
        log_info 'Kernel command line up to date'
    else
        _file_install "$quiet"
        log_info 'Kernel command line updated'
    fi
}

_configure_console() {
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

_configure_boot_loader() {
    local loader='boot/loader/loader.conf'

    log_step 'Configuring the boot loader'

    if _file_current "$loader"; then
        log_info 'Boot loader configuration up to date'
    else
        _file_install "$loader"
        log_info 'Boot loader configuration updated'
    fi

    if systemctl is-enabled --quiet systemd-boot-update.service; then
        log_info 'Automatic boot loader updates already enabled'
    else
        sudo systemctl enable --quiet systemd-boot-update.service
        log_info 'Automatic boot loader updates enabled'
    fi
}

_configure_zram() {
    local zram='etc/sysctl.d/99-vm-zram-parameters.conf'
    local swap='etc/systemd/zram-generator.conf.d/60-swap-size.conf'

    log_step 'Tuning swap on zram'

    if _file_current "$zram"; then
        log_info 'Memory settings up to date'
    else
        _file_install "$zram"
        log_info 'Memory settings updated'
    fi

    if _file_current "$swap"; then
        log_info 'Swap size up to date'
    else
        _file_install "$swap"
        log_info 'Swap size updated'
    fi
}

_configure_core_dumps() {
    local coredump='etc/sysctl.d/50-coredump.conf'

    log_step 'Disabling core dumps'

    if systemctl is-enabled --quiet systemd-coredumpd.service; then
        sudo systemctl disable --quiet --now systemd-coredumpd.service
        log_info 'Core dump service disabled'
    else
        log_info 'Core dump service already disabled'
    fi

    if _file_current "$coredump"; then
        log_info 'Core dump settings up to date'
    else
        _file_install "$coredump"
        sudo sysctl --quiet -p "/${coredump}"
        log_info 'Core dump settings updated'
    fi
}

configure_system() {
    _configure_cmdline
    _configure_console
    _configure_boot_loader
    _configure_zram
    _configure_core_dumps
}

rebuild_boot_images() {
    log_step 'Rebuilding the boot images'

    if ! sudo mkinitcpio -P; then
        die "Rebuilding the boot images failed, fix the error and run 'muen update' again"
    fi

    log_info 'Boot images rebuilt'
}

restart_system() {
    log_step 'Restarting the system'

    if ! systemctl reboot; then
        die 'Restarting failed, restart the system to apply the update'
    fi

    log_info 'Restart started'
}
