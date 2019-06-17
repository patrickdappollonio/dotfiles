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

    if [ ! -z "$KUBECONFIG" ]; then
        local kkf=$(basename $KUBECONFIG)
        PS1+="\[\e[97;44m\] $(echo ${kkf//.kubeconfig/}) \[\e[0m\] "
    fi

    if [ $EXIT != 0 ]; then
        PS1+="\[\e[0;31m\]●\[\e[0m\] "
    else
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

function gomod() {
    if [ "${GO111MODULE}" == "on" ]; then
        echo "Disabling Go modules"
        unset GO111MODULE
    else
        echo "Enabling Go modules"
        export GO111MODULE=on
    fi
}

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
export PATH=$PATH:$GOPATH/bin:/usr/local/sbin:$HOME/.local/bin

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

############################################################################
#                        KUBERNETES CONFIGURATIONS
############################################################################

# Set kubeconfig empty by default
export KUBECONFIG=""

# Automatically set kubeconfig env var
function change-k8() {
    local kks=$(ls ~/.kube/*.kubeconfig 2> /dev/null || true)
    echo "kubectl: select a kubeconfig file"

    # set the prompt used by select, replacing "#?"
    PS3="Use number to select a file or 'stop' to cancel: "

    # allow the user to choose a file
    select filename in $kks; do
        # leave the loop if the user says 'stop'
        if [[ "$REPLY" == stop ]]; then break; fi

        # complain if no file was selected, and loop to ask again
        if [[ "$filename" == "" ]]; then
            echo "'$REPLY' is not a valid number"
            continue
        fi

        # now we can use the selected file
        echo "kubectl config set to: $filename"
        export KUBECONFIG=$filename

        # it'll ask for another unless we leave the loop
        break
    done
}

# Change kubernetes namespace
function change-ns() {
    local namespace=$1
    if [ -z $namespace ]; then
        echo "Please provide the namespace name: \"change-ns ns-name\""
        return 1
    fi

    kubectl config set-context $(kubectl config current-context) --namespace $namespace
}

# Patch kubectl
function kubectl() {
    if [ -z "$KUBECONFIG" ]; then
        echo "kubectl: need a \$KUBECONFIG: use \"change-k8\" to set one."
        return 1
    fi

    if [ ! -f "$KUBECONFIG" ]; then
        echo "kubectl: file in \$KUBECONFIG does not exist: $KUBECONFIG"
        export KUBECONFIG=""
        return 1
    fi

    command kubectl "${@}"
}

# Shorthand for kubectl
function kc() {
    kubectl "${@}"
}
