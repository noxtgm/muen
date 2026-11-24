# archinstall configuration

Below is the selected configuration of the official `archinstall` installer, each H2 represents a top-level menu of the installer, H3 a sub-menu etc.

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

- None

### Disk encryption

- `LUKS` encryption type
- Encryption password set
- Default iteration time
- Root partition selected
- Default HSM (none)

## Swap

- Use swap on zram
- `zstd` zram compression algorithm

## Bootloader

- `Systemd-boot` bootloader
- Enabled unified kernel images
- Enabled Plymouth

## Kernels

- `linux` kernel

## Additional firmware

- None

## Hostname

- Default

## Authentication

### Root password

- None (root account stays locked)

### User account

- User account with superuser (sudo) access

### U2F login setup

- None

## Profile

- `Minimal` profile type

## Applications

### Bluetooth

- Disabled bluetooth configuration

### Audio

- `pipewire` audio configuration

### Print service

- Disabled print service configuration

### Power management

- `power-profiles-daemon` power management

### Firewall

- `ufw` firewall

### Additional fonts

- noto-fonts

## Network configuration

- Use Network Manager (default backend)

## Pacman

- Default

## Additional packages

- None

## Timezone

- Local timezone selected (not the UTC default)

## Automatic time sync (NTP)

- Default
