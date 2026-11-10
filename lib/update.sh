update_steps() {
    boot_configure
    packages_install
    boot_configure
    shell_set_default

    log_step 'Rebooting'
    systemctl reboot
}
