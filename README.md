# dots

Deployment and setup logic of opinionated dotfiles on a fresh Arch Linux install.

# Install

```sh
curl -fsSL https://raw.githubusercontent.com/<author>/<repo>/<branch>/install.sh | bash
```

# Usage

```sh
muen update
```

# Structure

```
.
├── bin/        # Update command-line entry point
├── configs/    # Configs linked over to ~/.config/
├── lib/        # Sourced shared helpers and logic
├── system/     # System-level configs appended or copied over
├── widgets/    # Styled widgets following a shared theme
├── install.sh  # Fresh install entry point
└── packages    # List of installed official packages
```
