#!/bin/sh
echo "Setting up Git configuration..."

# Set user details
git config --global user.email "johann.lieberwirth@web.de"
git config --global user.name "JohannKaspar"

# Set global .gitignore file
git config --global core.excludesfile "$HOME/.dotfiles/.gitignore_global"