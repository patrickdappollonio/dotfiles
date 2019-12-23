#!/bin/bash

# Find if it's linux what we are running
if [ "$(uname -s)" == "Darwin" ]; then
    IS_MAC_OS=true
    IS_LINUX_OS=false
elif [ "$(uname -s)" == "Linux" ]; then
    IS_MAC_OS=false
    IS_LINUX_OS=true
else
    IS_MAC_OS=false
    IS_LINUX_OS=false
fi

# Set environment variables depending on what operating
# system we're running
if [ "$IS_MAC_OS" = true ]; then
    export VERSION="MacOS"
    export CODENAME="Darwin"
    export BASH_SILENCE_DEPRECATION_WARNING=1
fi
if [ "$IS_LINUX_OS" = true ]; then
    # shellcheck disable=SC1091
    source /etc/os-release
    export VERSION=$ID
    export CODENAME=${VERSION_ID//./}
fi

# Add PS1 and improve history
PROMPT_COMMAND=__prompt_command
__prompt_command() {
    code="$?"
    PS1="\[\e[00;33m\]\u@\h\[\e[0m\]\[\e[00;37m\] \[\e[0m\]\[\e[01;36m\][\W]\$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/')\[\e[0m\]\[\e[00;36m\]\[\e[0m\]\[\e[00;37m\] \[\e[0m\]"

    if [ ! -z "$KUBECONFIG" ]; then
        kkf=$(basename "$KUBECONFIG")
        PS1+="\[\e[97;44m\] ${kkf//.yml/} \[\e[0m\] "
    fi

    if [ $code != 0 ]; then
        PS1+="\[\e[0;31m\]●\[\e[0m\] "
    else
        PS1+="\[\e[0;32m\]○\[\e[0m\] "
    fi
}

# Diverse aliases for my common tasks
[ "$IS_LINUX_OS" == "true" ] && alias ll='ls -lhaG --color=auto'
[ "$IS_MAC_OS" == "true" ] && alias ll='ls -lhaG'
alias l='ll'
alias ..='cd ..'
alias ...='cd ../..'

# Golang aliases
alias goi='go install'
alias gob='go build'
alias got='go test ./...'
alias gg='go get -u'
alias ggi='go get -u -insecure'

# Enable Go modules in an specific folder
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

# Configure Go's $GOPATH directory depending on
# the user's operating system
if [ "$IS_LINUX_OS" = true ] || [ "$IS_MAC_OS" = true ]; then
    export GOPATH=$HOME/Golang
fi

# Add Go's binary files to the system path
export PATH=$PATH:$GOPATH/bin

# MKDir and CD
function mkcd() {
    mkdir -p "$1" && cd "$1" || return
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

    cd "$(find-project "$1")" || return
}

# Source environment settings if found
if [ -f ~/.config/environment ]; then
    # shellcheck disable=SC1090
    source ~/.config/environment
fi

# Source .inputrc
if [ -f ~/.inputrc ]; then
    # shellcheck disable=SC1090
    bind -f ~/.inputrc
fi

# Enable Google App Engine if the folder exists
if [ -d ~/.appengine/ ]; then
    export PATH=$PATH:~/.appengine/
fi

# Enable local support for locally installed tools
if [ -d ~/.local/bin/ ]; then
    export PATH=$PATH:~/.local/bin/
fi

# Enable NodeJS' NVM if path exists
export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1090
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
# shellcheck disable=SC1090
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

############################################################################
#                        KUBERNETES CONFIGURATIONS
############################################################################

# Automatically set kubeconfig env var
function change-k8() {
    kks=$(ls ~/.kube/*.yml 2> /dev/null || true)
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
    if [ -z "$namespace" ]; then
        echo "Please provide the namespace name: \"change-ns ns-name\""
        return 1
    fi

    kubectl config set-context "$(kubectl config current-context)" --namespace "$namespace"
}

# Patch kubectl
function kubectl() {
    if [ -z "$KUBECONFIG" ]; then
        change-k8
    fi

    if [ ! -f "$KUBECONFIG" ]; then
        echo "kubectl: file in \$KUBECONFIG does not exist: $KUBECONFIG"
        export KUBECONFIG=""
        return 1
    fi

    command kubectl "${@}"
}

# shellcheck source=/dev/null
if [ -x "$(command -v kubectl)" ]; then
    source <(command kubectl completion bash)
fi

# Shorthand for kubectl
alias kc='kubectl'
alias kns='change-ns'
alias ks='change-k8'
alias k8='change-k8'
alias k='kubectl'
alias tf='terraform'

complete -F __start_kubectl k
complete -F __start_kubectl kc

# Create a temporary directory and cd into it
function td() {
    dir=$(mktemp -d 2>/dev/null || mktemp -d -t 'tempdir')
    cd "${dir}" || return
}

function cleantd() {
    local tdlocation
    tdlocation=$(dirname "$(mktemp -d -u)")
    rm -rf "$tdlocation/tmp.*"
}

################################################################

function repeat() {
    clear
    while true; do
        eval "$@"
        sleep 1
    done
}

function headers() {
    curl -sD - -o /dev/null "$@"
}
