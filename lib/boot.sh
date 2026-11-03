_boot_configure_cmdline() {
    local cmdline=/etc/cmdline.d/quiet.conf
    local source="${REPO_PATH}/system${cmdline}"

    log_step 'Configuring the kernel command line'

    if [[ -f "$cmdline" && "$(< "$cmdline")" == "$(< "$source")" ]]; then
        log_info 'Kernel command line up to date'
        return
    fi

    sudo install -Dm 644 -- "$source" "$cmdline"

    if ! sudo mkinitcpio -P; then
        sudo rm -f -- "$cmdline"
        die 'Rebuilding the boot images failed, kernel command line not changed'
    fi

    log_info 'Kernel command line updated'
}

_boot_configure_loader() {
    log_step 'Configuring the boot loader'

    sudo install -m 644 -- "${REPO_PATH}/system/boot/loader/loader.conf" /boot/loader/loader.conf
    sudo systemctl enable --quiet systemd-boot-update.service

    log_info 'Boot loader configured'
}

_boot_configure_zram() {
    log_step 'Tuning swap on zram'

    sudo install -Dm 644 -- "${REPO_PATH}/system/etc/sysctl.d/90-vm-zram-parameters.conf" /etc/sysctl.d/90-vm-zram-parameters.conf
    sudo install -Dm 644 -- "${REPO_PATH}/system/etc/systemd/zram-generator.conf.d/50-size.conf" /etc/systemd/zram-generator.conf.d/50-size.conf

    log_info 'Swap on zram tuned'
}

boot_configure() {
    _boot_configure_cmdline
    _boot_configure_loader
    _boot_configure_zram
}
