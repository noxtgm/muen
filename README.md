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

The boot menu can be accessed by holding space when powering on.

Pulls the latest changes, installs packages, and copies the configs from `home/` into `~`.

## Layout

| Path | Contents |
|---|---|
| `install.sh` | Entry point |
| `packages` | Official packages list |
| `bin/` | CLI command |
| `lib/` | Sourced helpers |
| `home/` | Configs copied over |
| `widgets/` | Styled widgets |
