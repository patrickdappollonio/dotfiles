#!/bin/bash
set -euo pipefail

# Remove previous symlinks
function destroy_symlinks() {
    rm -rf ~/.bash_profile
    rm -rf ~/.inputrc
    rm -rf ~/.gitconfig
    rm -rf ~/.tmux.conf
    rm -rf ~/.alacritty.toml
    rm -rf ~/.config/nvim
}

# Add new symlinks
function create_symlinks() {
    mkdir -p "$HOME/.config/{nvim,ghostty}"
    ln -s ~/.dotfiles/.bash_profile ~/.bash_profile
    ln -s ~/.dotfiles/.inputrc ~/.inputrc
    ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
    ln -s ~/.dotfiles/.tmux.conf ~/.tmux.conf
    ln -s ~/.dotfiles/.alacritty.toml ~/.alacritty.toml
    ln -s ~/.dotfiles/nvim ~/.config/nvim
    ln -s ~/.dotfiles/ghostty ~/.config/ghostty
}

# Options for the command
if [[ $1 = "create" ]]; then
    create_symlinks
elif [[ $1 = "update" ]]; then
    destroy_symlinks
    create_symlinks
elif [[ $1 = "delete" ]]; then
    destroy_symlinks
fi
