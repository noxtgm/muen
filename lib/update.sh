update_steps() {
    packages_install
    boot_configure

    log_step 'Rebooting'
    systemctl reboot
}
