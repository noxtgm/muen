update_steps() {
    packages_install
    boot_configure
    configs_deploy
    shell_set_default
    boot_images_rebuild

    log_step 'Rebooting'
    systemctl reboot
}
