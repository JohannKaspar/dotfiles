#!/bin/sh
echo "Setting up Git configuration..."

# Set user details
git config --global user.email "63501587+JohannKaspar@users.noreply.github.com"
git config --global user.name "JohannKaspar"

# Set global .gitignore file
git config --global core.excludesfile "$HOME/.dotfiles/.gitignore_global"