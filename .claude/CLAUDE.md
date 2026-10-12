This project is specifically configured and tuned to be installed on the latest version of Arch Linux that was installed fresh using `archinstall`. With the following archinstall configuration:

# Disk configuration

## Partitioning

- Best-effort default partition layout
- `ext4` filesystem
- No separate partition for /home

## Disk encryption

- LUKS encryption type

# Swap

- Enabled swap on zram
- `zstd` zram compression algorithm

# Bootloader

- `Systemd-boot` bootloader
- Enabled unified kernel images

# Kernels

- `linux` kernel

# Additional firmware

- Noto font

# Authentication

## User account

- User account with sudo root access

# Profile

- `Minimal` profile type

# Applications

## Bluetooth

- Enabled bluetooth configuration

## Audio

- `pipewire` audio configuration

## Print service

- Disabled print service configuration

## Power management

- `tuned` power management

## Firewall

- `ufw` firewall

## Additional fonts

- TBA

# Network configuration

- Use Network Manager (default backend)

# Additional packages

- None
