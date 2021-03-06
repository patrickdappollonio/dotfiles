#!/bin/bash
set -euo pipefail

# Remove previous symlinks
function destroy_symlinks() {
    rm -rf ~/.bash_profile
    rm -rf ~/.inputrc
    rm -rf ~/.gitconfig
    rm -rf ~/.vimrc
    rm -rf ~/.vim
    rm -rf ~/.tmux.conf
    rm -rf ~/.alacritty.yml
}

# Add new symlinks
function create_symlinks() {
    ln -s ~/.dotfiles/.bash_profile ~/.bash_profile
    ln -s ~/.dotfiles/.inputrc ~/.inputrc
    ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
    ln -s ~/.dotfiles/.vimrc ~/.vimrc
    ln -s ~/.dotfiles/.vim ~/.vim
    ln -s ~/.dotfiles/.tmux.conf ~/.tmux.conf
    ln -s ~/.dotfiles/alacritty.yml ~/.alacritty.yml
}

# Options for the command
if  [[ $1 = "create"  ]]; then
    create_symlinks
elif  [[ $1 = "update"  ]]; then
    destroy_symlinks
    create_symlinks
elif  [[ $1 = "delete"  ]]; then
    destroy_symlinks
fi
