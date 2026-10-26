# MUEN

Deployment and setup logic for opinionated dotfiles on a fresh Arch Linux install.

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

The boot menu can be accessed by holding space when powering on.

## Layout

| Path | Contents |
|---|---|
| `install.sh` | Entry point |
| `pacman.pkgs` | Official packages list |
| `bin/` | CLI command |
| `lib/` | Sourced helpers |
| `home/` | Configs copied over |
| `widgets/` | Styled widgets |
