boot_configure() {
    local system="${REPO_PATH}/system"

    log_step 'Configuring the boot loader'

    sudo install -m 644 -- "${system}/boot/loader/loader.conf" /boot/loader/loader.conf
    sudo systemctl enable --quiet systemd-boot-update.service

    log_info 'Boot loader configured'

    log_step 'Tuning swap on zram'

    sudo install -Dm 644 -- "${system}/etc/sysctl.d/99-vm-zram-parameters.conf" /etc/sysctl.d/99-vm-zram-parameters.conf

    log_info 'Swap on zram tuned'
}
