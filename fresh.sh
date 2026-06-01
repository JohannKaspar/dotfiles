#!/bin/sh

echo "Setting up your Mac..."

# Check for Oh My Zsh and install if we don't have it
if test ! $(which omz); then
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf $HOME/.zshrc
ln -sw $HOME/.dotfiles/.zshrc $HOME/.zshrc

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew bundle --file ./Brewfile

# Create projects directory
mkdir -p $HOME/Projects

# Configure git identity and global gitignore
source ./gitconfig.sh

# Symlink Hammerspoon and Karabiner configs from the repo
mkdir -p $HOME/.hammerspoon
[ -e $HOME/.hammerspoon/init.lua ] && [ ! -L $HOME/.hammerspoon/init.lua ] && mv $HOME/.hammerspoon/init.lua $HOME/.hammerspoon/init.lua.backup
ln -sf $HOME/.dotfiles/configs/hammerspoon/init.lua $HOME/.hammerspoon/init.lua

mkdir -p $HOME/.config/karabiner
[ -e $HOME/.config/karabiner/karabiner.json ] && [ ! -L $HOME/.config/karabiner/karabiner.json ] && mv $HOME/.config/karabiner/karabiner.json $HOME/.config/karabiner/karabiner.json.backup
ln -sf $HOME/.dotfiles/configs/karabiner/karabiner.json $HOME/.config/karabiner/karabiner.json

# Install Zotero MCP server (used by Claude Desktop, configured in ~/Library/Application Support/Claude/claude_desktop_config.json)
uv tool install "zotero-mcp-server[all]"

# Install and load launchd agents for the Obsidian Research vault automation:
#   - zotero-annotation-sync: watches Zotero SQLite + Topics/, syncs paper notes
#   - research-daily-summary: weekdays 18:30, drafts the daily note via Claude
mkdir -p $HOME/Library/LaunchAgents
for plist in $HOME/.dotfiles/configs/launchd/*.plist; do
  name=$(basename "$plist")
  target="$HOME/Library/LaunchAgents/$name"
  [ -e "$target" ] && [ ! -L "$target" ] && mv "$target" "$target.backup"
  ln -sf "$plist" "$target"
  launchctl unload "$target" 2>/dev/null
  launchctl load "$target"
done

# Clone Github repositories
./clone.sh

# Set macOS preferences - we will run this last because this will reload the shell
source ./.macos
