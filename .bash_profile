#!/bin/bash

# Find if it's linux what we are running
[ "$(uname -s)" == "Darwin" ] && IS_MAC_OS=true
[ "$(uname -s)" == "Linux" ] && IS_LINUX_OS=true
[[ "$(uname -r)" =~ "WSL" ]] && IS_WSL=true

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

    if [ -n "$KUBECONFIG" ]; then
        kkf=$(basename "$KUBECONFIG")
        PS1+="\[\e[97;44m\] ${kkf//.yml/} \[\e[0m\] "
    fi

    PS1+="\n"

    local icon="$"
    if [ "$USER" == "root" ]; then
        icon="#"
    fi

    if [ $code != 0 ]; then
        PS1+="\[\e[0;31m\]$icon\[\e[0m\] "
    else
        PS1+="\[\e[0;32m\]$icon\[\e[0m\] "
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
alias got='go test -json -cover -count=1 ./... | tparse -all'
alias gg='go get -u'
alias ggi='go get -u -insecure'
alias gobs='CGO_ENABLED=0 go build -a -tags netgo -trimpath -ldflags "-s -w -extldflags '\''-static'\''" .'

# tmux alias to run 256-color
alias tmux='tmux -2'

# Configure Go's $GOPATH directory depending on
# the user's operating system
if [ "$IS_LINUX_OS" = true ] || [ "$IS_MAC_OS" = true ]; then
    export GOPATH=$HOME/Golang
fi

# Add some of our paths to the Path
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$HOME/.cargo/bin/
export PATH=$PATH:$HOME/.dotfiles/bin
export PATH=$HOME/.krew/bin:$PATH
export PATH=/opt/homebrew/bin:$PATH
export HOMEBREW_NO_ENV_HINTS="true"

# MKDir and CD
function mkcd() {
    mkdir -p "$1" && cd "$1" || return
}

# Set vim as the default editor on Linux
if [ "$IS_LINUX_OS" = true ] || [ "$IS_MAC_OS" = true ]; then
    export VISUAL=nvim
    export EDITOR="$VISUAL"
fi

# Golang switch, requires `find-project`: github.com/patrickdappollonio/find-project
function gs() {
    if ! type "find-project" > /dev/null; then
        echo -e "Install find-project first by doing: go get -u -v github.com/patrickdappollonio/find-project"
    fi

    cd "$(find-project "$1")" || return
}

# Download projects by cloning them, requires `gc-rust`: github.com/patrickdappollonio/gc-rust
function gc() {
    if ! type "gc-rust" > /dev/null; then
        echo -e "Install gc-rust first from github.com/patrickdappollonio/gc-rust"
    fi

    cd "$(gc-rust "$1")" || return
}

# Alias cat to bat if it's installed
function cat() {
    if [ -x "$(command -v bat)" ]; then
        bat "$@" --style=numbers,changes,grid --paging=never
    else
        command cat "$@"
    fi
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

# Add alacritty to path if found
if [ -d /Applications/Alacritty.app/Contents/MacOS/ ]; then
    export PATH=$PATH:/Applications/Alacritty.app/Contents/MacOS/
fi

# Enable support for Yarn (NodeJS) binaries
if [ -d ~/.yarn/bin/ ]; then
    export PATH=$PATH:~/.yarn/bin/
fi

# Enable locally installed "krew" plugins
if [ -d ~/.krew/bin/ ]; then
    export PATH=$PATH:~/.krew/bin/
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
    # check if we have a kubeconfig file AND the kubeconfig env var is not set
    if [ -z "$KUBECONFIG" ] && [ -f "$HOME/.kube/config" ]; then
        export KUBECONFIG="$HOME/.kube/config"
    fi

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

# Shorthand for terraform
alias tf='terraform'

# Create a temporary directory and cd into it
function td() {
    rand=$(echo $RANDOM | md5sum | head -c 8)
    dir="${GOPATH}/src/github.com/patrickdappollonio/temp-${rand}"
    mkdir -p "$dir" && cd "$dir" || return
}

# Delete all temp folders
function cleantd() {
    folders=$(find "${GOPATH}/src/github.com/patrickdappollonio/" -maxdepth 1 -name "temp-*" -type d -not -path '*/\.*')
    for f in $folders; do
        echo "Removing temp folder $f"
        rm -rf "$f"
    done
}

# Swap to neovim, since I keep forgetting to do so
if [ -x "$(command -v nvim)" ]; then
    alias vim=nvim
fi

# Fix WSL interop on a long-lived tmux session
function wsl_interop() {
    for socket in /run/WSL/*; do
       if ss -elx | grep -q "$socket"; then
          export WSL_INTEROP=$socket
       else
          rm "$socket" 2> /dev/null
       fi
    done

    if [[ -z $WSL_INTEROP ]]; then
       echo -e "\033[31mNo working WSL_INTEROP socket found !\033[0m"
    fi
}

# Add a fix for WSL interop in VSCode from the terminal
function code() {
    [ "$IS_WSL" == true ] && wsl_interop
    command code "${@}"
}

# Add Rust cargo env vars if found
if [ -f "$HOME/.cargo/env" ]; then
    # shellcheck disable=SC1091
    . "$HOME/.cargo/env"
fi

# Configure colima if it exists
if [ -f "$HOME/.colima/default/docker.sock" ]; then
    export DOCKER_SOCK="unix://$HOME/.colima/default/docker.sock"
    export DOCKER_DEFAULT_PLATFORM=linux/amd64
fi

# Configure SSH agent
if [ ! -S ~/.ssh/ssh_auth_sock ]; then
    eval "$(ssh-agent)"
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
ssh-add -l > /dev/null || ssh-add
