# dots

Deployment and setup logic of opinionated dotfiles on a fresh Arch Linux install.

# Install

```sh
curl -fsSL https://raw.githubusercontent.com/noxtgm/muen/main/install.sh | bash
```

# Usage

```sh
muen update          # Update the clone from the remote and deploy its configs
muen update --force  # Same logic but discards local changes and untracked files in the clone and overwrites conflicting files in the home directory
```

# Layout

```
.
├── install.sh        Bootstrap install entry point
├── packages          Official repository package names
├── bin/muen          Dotfiles update command-line entry point
├── lib/              Sourced shared helpers and logic
├── root/             Deployed files laid out as on the machine
│   ├── boot/         System configs copied over to /boot/ by lib/system.sh
│   ├── etc/          System configs copied over to /etc/ by lib/system.sh
│   └── home/user/    User files linked into $HOME by deploy_configs
│       └── .config/  User configs deployed to ~/.config/
└── widgets/          Styled widgets matching a shared theme
```
