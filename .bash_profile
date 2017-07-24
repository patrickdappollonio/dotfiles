#!/bin/bash

# Find if it's linux what we are running
if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    IS_LINUX_OS=true
else
    IS_LINUX_OS=false
fi

# Env vars
if [ "$IS_LINUX_OS" = true ]; then
    export VERSION=$(lsb_release -sc)
    export CODENAME=$(lsb_release -sr)
fi

# Simple way to print the git branch
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Add PS1
export PS1="\[\e[00;33m\]\u\[\e[0m\]\[\e[00;37m\]@\h \[\e[0m\]\[\e[01;36m\][\W]\$(parse_git_branch)\[\e[0m\]\[\e[00;36m\]:\[\e[0m\]\[\e[00;37m\] \[\e[0m\]"

# Diverse aliases for my common tasks
alias ll='ls -asFhlG --color=auto'
alias l="ll"
alias ..='cd ..'
alias ...='cd ../..'

# Golang aliases
alias goi='go install'
alias gob='go build'
alias got="go test \$(go list ./... | grep -v '/vendor/')"

# tmux alias to run 256-color
alias tmux='tmux -2'

# Golang setup
if [ "$IS_LINUX_OS" = true ]; then
    export GOPATH=$HOME/Golang
else
    export GOPATH=/c/Golang
fi
export PATH=$PATH:$GOPATH/bin

# Other commonly used aliases
alias gd='cd $HOME/Development'

# Pbcopy and pbpaste
if [ "$IS_LINUX_OS" = true ]; then
    if ! [ -x "$(command -v xclip)" ]; then
        echo -e "xclip is not installed, install it by doing 'apt-get install xclip'"
    fi

    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
    alias pbc="tmux loadb -"
    alias pbp="tmux saveb -"
fi

# Open folders
if [ "$IS_LINUX_OS" = false ]; then
    alias open="start"
fi

# MKDir and CD
function mkcd() {
    mkdir -p $1 && cd $1
}

# Set vim as the default editor on Linux
if [ "$IS_LINUX_OS" = true ]; then
    export VISUAL=vim
    export EDITOR="$VISUAL"
fi

# Golang switch, requires `find-project`: github.com/patrickdappollonio/find-project
function gs() {
    if ! type "find-project" > /dev/null; then
        echo -e "Install find-project first by doing: go get -u -v github.com/patrickdappollonio/find-project"
    fi

    cd $(find-project $1)
}

# Colorized cat for Linux
function ccat() {
    if [ "$IS_LINUX_OS" = true ]; then
        if ! [ -x "$(command -v highlight)" ]; then
            echo -e "highlight command not installed, install it by doing 'apt-get install highlight'"
        fi

        highlight -O ansi $1
    else
        command cat $1
    fi
}

# Go get with update and verbose
function gg() {
    go get -u -v $1
}

# Source HPE-specific settings
source ~/.dotfiles/.hpe_proxy.sh

# Source Amazon AWS data
if [ -f ~/.dotfiles/.awsdetails ]; then
    source ~/.dotfiles/.awsdetails
fi

# Enable Google App Engine if the folder exists
if [ -d ~/.appengine/ ]; then
    export PATH=$PATH:~/.appengine/
fi

# Enable NodeJS' NVM if path exists
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
