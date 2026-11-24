# Context

Dotfiles and deployment scripts for one machine: the latest Arch Linux, freshly installed with `archinstall`, used by a single person. The selected `archinstall` configuration and options are detailed in @CONFIGURATION.md

# Scope

The project is not complete or stable yet, so keep every change aimed at that one target:
- Target a fresh `archinstall` and the current version of this repo only
- Don't write migration or cleanup code for machines set up with an earlier version, and don't add notes on how an existing machine would pick up a change
- Assume one user and one run at a time, don't add multi-user handling or guards against concurrent runs

## Layout

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

# Security

Security comes before convenience. When a choice trades one for the other (autologin, skipping a password, looser permissions, fewer prompts), implement the secure option and mention the convenient one with its security cost, so the user can decide whether to switch.

Changes to how the user authenticates, or to what can capture input or the screen, need the user's approval before they go in. First audit the change: check its claims against both the source and the documentation, and test its failure modes in the container. Then present the audit and the proposed diff. Prefer designs that fail closed: a failure should end at a password prompt, never at an open shell or an unlocked session.

# Follow upstream

Follow the official documentation (upstream manual, Arch Wiki, man pages) for the version of each tool that Arch currently ships. On a rolling release that is the version in the official repositories, which can lag behind or differ from upstream's newest release. Check it with `pacman -Si <package>` in the container instead of assuming it from memory or from older search results.

In your summary, cite the doc and version each change follows. Add a short comment with the link next to any setting that isn't obvious from the docs.

If you think a departure from the recommended setup would be better, implement the recommended setup and propose the departure separately: what it changes, why, and what it costs. Apply it only after the user approves.

# Testing

Reasoning alone isn't verification: test behavior in a throwaway `archlinux:latest` container.

Test everything the container can show. For what it can't, say so and give the user a short manual check to run on the real machine.

Interactive behavior (key bindings, completion, widgets) needs a terminal. Drive it with tmux inside the container: `tmux send-keys` for input, then `tmux capture-pane -p` to read the screen.

Label everything you create with `--label dots-test`. When the task is done, remove those containers (`docker ps -aq --filter label=dots-test | xargs -r docker rm -f`) and any images you built.

# Verify what you claim

The most common failure is confident output that was never executed.
- Read the code you are changing before you change it
- When you state a fact about the codebase, cite the file and line you read it from
- Back claims about how a tool behaves with its documentation for the shipped version, or with a test
- Say plainly what you did not verify: "The logic is sound but I haven't run it" is useful; silence is not
- Never claim something works because it should

# Reading documentation

wiki.archlinux.org answers automated fetches with a bot check; instead read Arch Wiki pages from the `arch-wiki-docs` package in a container. That copy is a snapshot, and its package version is its date. Cite that date. If a detail might have changed since, carry on with the snapshot and ask the user to save the live page.

man.archlinux.org serves man pages for the versions in the repositories, shows the package version on each page, and can be fetched directly.

Other docs (upstream sites, GitHub, freedesktop specs) can be fetched directly. Docs sites get reorganised often, so search for the current URL rather than guessing it.

# When something here can't be done

If a rule can't be followed in your environment (no Docker, a page you can't reach, a check that needs the real machine), don't stall and don't skip it silently. Do what you can, say what you couldn't, and finish the rest of the task. Save questions and approval requests for the end of your work, unless the answer would change what you build.
