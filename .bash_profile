#!/bin/bash

# Find if it's linux what we are running
if [ "$(uname)" == "Darwin" ]; then
    IS_MAC_OS=true
    IS_LINUX_OS=false
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    IS_LINUX_OS=true
else
    IS_LINUX_OS=false
fi

# Env vars
if [ "$IS_MAC_OS" = true ]; then
    export VERSION="MacOS"
    export CODENAME="Darwin"
elif [ "$IS_LINUX_OS" = true ]; then
    if ! [ -x "$(command -v lsb_release)" ]; then
        export VERSION=$(cat /etc/system-release-cpe | awk -F: '{ print $3 }')
        export CODENAME=$(cat /etc/system-release-cpe | awk -F: '{ print $5 }' | grep -o ^[0-9]*)
    else
        export VERSION=$(lsb_release -sc)
        export CODENAME=$(lsb_release -sr)
    fi
fi

# Add PS1
PROMPT_COMMAND=__prompt_command
__prompt_command() {
    local EXIT="$?"
    PS1="\[\e[00;33m\]\u\[\e[0m\]\[\e[00;37m\] \[\e[0m\]\[\e[01;36m\][\W]\$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/')\[\e[0m\]\[\e[00;36m\]\[\e[0m\]\[\e[00;37m\] \[\e[0m\]"

    if [ $EXIT != 0 ]; then
        # PS1+="\[\e[0;31m\]⚑\[\e[0m\] → "
        PS1+="\[\e[0;31m\]●\[\e[0m\] "
    else
        # PS1+="\[\e[0;32m\]⚑\[\e[0m\] → "
        PS1+="\[\e[0;32m\]○\[\e[0m\] "
    fi
}

# Diverse aliases for my common tasks
alias ll='ls -lhaG'
alias l="ll"
alias ..='cd ..'
alias ...='cd ../..'

# Golang aliases
alias goi='go install'
alias gob='go build'
alias got="go test ./..."

# tmux alias to run 256-color
alias tmux='tmux -2'

# Golang setup
if [ "$IS_LINUX_OS" = true ]; then
    export GOPATH=$HOME/Golang
elif [ "$IS_MAC_OS" = true ]; then
    export GOPATH=$HOME/Golang
else
    export GOPATH=/c/Golang
fi

# Add Go's binary files to the system path
export PATH=$PATH:$GOPATH/bin

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

# Gofat returns sizes of binaries
function gofat() {
    eval `go build -work -a 2>&1` && find $WORK -type f -name "*.a" | xargs -I{} du -hxs "{}" | sort -rh | sed -e s:${WORK}/::g
}

# Go get with update and verbose
function gg() {
    go get -u -v $1
}

# Go get with update, verbose but also allowing insecure sources
function ggi() {
    go get -u -v -insecure $1
}

# Source environment settings if found
if [ -f ~/.config/environment ]; then
    source ~/.config/environment
fi

# Enable Google App Engine if the folder exists
if [ -d ~/.appengine/ ]; then
    export PATH=$PATH:~/.appengine/
fi

# Enable NodeJS' NVM if path exists
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# Add some extra paths to the path
export PATH="$PATH:/usr/local/sbin:$HOME/.local/bin"
