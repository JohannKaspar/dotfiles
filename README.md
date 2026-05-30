<p align="center"><img src="art/banner-2x.png"></p>

## Introduction

Personal dotfiles for setting up and maintaining my Mac. Based on the [driesvints/dotfiles](https://github.com/driesvints/dotfiles) template, trimmed and adapted to my workflow (research, ML, embedded).

## A Fresh macOS Setup

### Before you leave the old Mac

- Push every branch you care about.
- Save anything that isn't in iCloud / Dropbox / OneDrive.
- Export local databases.
- Verify your Obsidian vault, 1Password vault, and cloud accounts are synced.
- Move secrets into 1Password — they are deliberately **not** in this repo:
  - `~/.api_keys`
  - `~/.ssh/config` and `~/.ssh/id_*` (or use the 1Password SSH agent)
  - `~/.kaggle/kaggle.json`
  - `~/.config/rclone/rclone.conf` (contains OAuth tokens)
  - `~/.docker/config.json` (may contain registry credentials)
  - Tunnelblick `.tblk` profiles (`~/Library/Application Support/Tunnelblick/Configurations/`)
- For apps with native cloud sync, just sign in on the new Mac — no manual export needed: VS Code (Settings Sync), Cursor, Claude, ChatGPT, Slack, Discord, Telegram, Signal, Spotify, NordVPN, Obsidian, 1Password.
- Hammerspoon and Karabiner configs are versioned in this repo under [`configs/`](./configs) — keep them current.

### Setting up the new Mac

1. Update macOS to the latest version.
2. Set up an SSH key:
   - With 1Password: enable the [1Password SSH agent](https://developer.1password.com/docs/ssh/get-started/#step-3-turn-on-the-1password-ssh-agent) and sync keys.
   - Or generate fresh:
     ```zsh
     curl https://raw.githubusercontent.com/JohannKaspar/dotfiles/HEAD/ssh.sh | sh -s "<your-email>"
     ```
3. Clone this repo:
    ```zsh
    git clone --recursive git@github.com:JohannKaspar/dotfiles.git ~/.dotfiles
    ```
4. Run the installer:
    ```zsh
    cd ~/.dotfiles && ./fresh.sh
    ```
   This installs Oh My Zsh, Homebrew, everything in [`Brewfile`](./Brewfile), symlinks `.zshrc`, configures git, creates `~/Projects/`, symlinks the Hammerspoon + Karabiner configs from [`configs/`](./configs), and applies macOS defaults from [`.macos`](./.macos).
5. Restore `~/.api_keys` and the other secrets listed above from 1Password.
6. Start apps that need post-install login (1Password first, then VS Code/Cursor/Claude/ChatGPT/Slack/Discord/Spotify/NordVPN/Ledger Wallet/Zotero/Obsidian). Settings sync down automatically where supported.
7. Reboot.

## What's in here

- [`Brewfile`](./Brewfile) — formulae, casks, MAS apps, VS Code extensions.
- [`.zshrc`](./.zshrc) — Oh My Zsh setup with the `minimal` theme; sources `~/.api_keys`.
- [`aliases.zsh`](./aliases.zsh) — git/k8s shortcuts and the `workon`/`activate` helpers for `~/Projects/<name>/.venv`.
- [`path.zsh`](./path.zsh) — `$PATH` additions (loaded via `ZSH_CUSTOM`).
- [`.macos`](./.macos) — macOS defaults (Finder, Dock, screenshots, etc.).
- [`gitconfig.sh`](./gitconfig.sh) — global git identity + excludes file.
- [`ssh.sh`](./ssh.sh) — bootstrap a fresh ed25519 SSH key.
- [`fresh.sh`](./fresh.sh) — orchestrates the full install.
- [`clone.sh`](./clone.sh) — clones the repos you want into `~/Projects/`. Edit before running on a new Mac.
- [`configs/hammerspoon/init.lua`](./configs/hammerspoon/init.lua) — Hammerspoon config, symlinked to `~/.hammerspoon/init.lua`.
- [`configs/karabiner/karabiner.json`](./configs/karabiner/karabiner.json) — Karabiner-Elements config, symlinked to `~/.config/karabiner/karabiner.json`.
- [`scripts/`](./scripts) — SSH tunnels for remote Jupyter/TensorBoard and an rsync download helper.

## Maintenance

- Keep the Brewfile current: `brew bundle dump --force --file=Brewfile` (review the diff before committing — `dump` may add things you don't want).
- Periodically: `brew bundle cleanup --file=Brewfile --dry-run` to spot drift.
- The Hammerspoon / Karabiner files in `configs/` are symlinked into place by `fresh.sh`, so editing them in either location updates the repo. After tweaking, just `git commit`.

## Credits

Forked from [driesvints/dotfiles](https://github.com/driesvints/dotfiles). Theme by [@subnixr](https://github.com/subnixr).
