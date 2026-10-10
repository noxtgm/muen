# muen

Dotfiles and setup script for a fresh Arch Linux install.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/noxtgm/muen/main/install.sh | bash
```

## Usage

```sh
muen update
```

Pulls the latest changes, installs packages, and copies the configs from `home/` into `~`.

Configs edited locally that an update would overwrite are skipped and listed. Remove them and re-run, or overwrite them with `muen update --force`. The local copies are backed up to `~/.local/state/muen/backups/`.

## Layout

| Path | Contents |
|---|---|
| `install.sh` | Entry point |
| `bin/muen` | `muen` command |
| `lib/` | Helpers sourced by `muen` |
| `home/` | Configs, copied into `~` by `muen update` |
| `packages.pacman` | Official packages |
| `packages.aur` | AUR packages |
| `packages.npm` | npm packages |
