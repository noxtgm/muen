# Context

This project contains dotfiles and deployment scripts specifically configured and tuned to be deployed on the latest version of Arch Linux freshly installed using `archinstall`. It is to be used with a single SSD drive machine.

# Configuration

Each H2 represents a configuration tab in the official `archinstall` installation tool.

## Archinstall language

- Default

## Locales

- Default

## Mirrors and repositories

- Default

## Disk configuration

### Partitioning

- Use a best-effort default partition layout
- `ext4` main filesystem
- No separate partition for /home

### LVM

### Disk encryption

- LUKS disk encryption type

## Swap

- Use swap on zram
- `zstd` zram compression algorithm

## Bootloader

- `Systemd-boot` bootloader
- Enabled unified kernel images
- Enabled Plymouth with `bgrt` template

## Kernels

- `linux` kernel

## Additional firmware

- None

## Hostname

- Default

## Authentication

### Root password

- Default

### User account

- User account with sudo root access

## Profile

- `Minimal` profile type

## Applications

### Bluetooth

- Enabled bluetooth configuration

### Audio

- `pipewire` audio configuration

### Print service

- Disabled print service configuration

### Power management

- `tuned` power management

### Firewall

- `ufw` firewall

### Additional fonts

- noto-fonts

## Network configuration

- Network Manager (default backend)

## Pacman

- Default

## Additional packages

- None

## Timezone

- Default

## Automatic time sync

- Default
