#!/bin/bash

# Find if it's macOS, Linux, or WSL that we are running
[ "$(uname -s)" = "Darwin" ] && IS_MAC_OS=true
[ "$(uname -s)" = "Linux" ] && IS_LINUX_OS=true
grep -qEi "(Microsoft|WSL)" /proc/version &>/dev/null && IS_WSL=true

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
        PS1+="\[\e[97;44m\] \[\e[97m\]${kkf//.yml/} \[\e[0m\] \[\e[0m\] "
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
if [ "$IS_LINUX_OS" = true ]; then
    alias ll='ls -lha --color=auto'
fi

if [ "$IS_MAC_OS" = true ]; then
    alias ll='ls -lhaG'
fi

alias l='ll'
alias ..='cd ..'
alias ...='cd ../..'

# Golang aliases
alias goi='go install'
alias gob='go build'
alias got='go test -json -cover -count=1 ./... | tparse -all'
alias gots='go test -short -json -cover -count=1 ./... | tparse -all'
alias gg='go get -u'
alias ggi='go get -u -insecure'
alias gobs='CGO_ENABLED=0 go build -a -tags netgo -trimpath -ldflags "-s -w -extldflags '\''-static'\''" .'

# Disable Homebrew's environment hints
export HOMEBREW_NO_ENV_HINTS="true"

# Configure Go's $GOPATH directory
if [ -z "$GOPATH" ]; then
    export GOPATH="$HOME/Golang"
fi

# Array of paths to add to PATH
declare -a paths_to_add=(
    "$GOPATH/bin"                                # Go binaries
    "$HOME/.cargo/bin"                           # Rust binaries
    "$HOME/.dotfiles/bin"                        # Custom binaries
    "/opt/homebrew/bin"                          # Homebrew binaries
    "$HOME/.krew/bin"                            # Krew binaries
    "$HOME/.local/bin"                           # Local binaries
    "$HOME/.yarn/bin"                            # Yarn binaries
    "/Applications/Alacritty.app/Contents/MacOS" # Alacritty
    "$HOME/.foundry/bin"                         # Foundry binaries
)

# Add existing directories to PATH, avoiding duplicates
for dir in "${paths_to_add[@]}"; do
    if [ -d "$dir" ] && [[ ":$PATH:" != *":$dir:"* ]]; then
        export PATH="$PATH:$dir"
    fi
done

# Set NVM_DIR and create array of files to source
export NVM_DIR="$HOME/.nvm"

# Array of files to source if they exist
declare -a files_to_source=(
    "$HOME/.config/environment" # Custom environment variables
    "$HOME/.cargo/env"          # Rust environment variables
    "$NVM_DIR/nvm.sh"           # NVM environment variables
    "$NVM_DIR/bash_completion"  # NVM bash completions
)

# Source files if they exist
for file in "${files_to_source[@]}"; do
    if [ -f "$file" ]; then
        # shellcheck disable=SC1090
        source "$file"
    fi
done

# MKDir and CD
function mkcd() {
    mkdir -p "$1" && cd "$1" || return
}

# Set Neovim as the default editor on Linux and macOS
if command -v nvim &>/dev/null; then
    export VISUAL="nvim"
    export EDITOR="$VISUAL"
    alias vim='nvim'
else
    export VISUAL="vim"
    export EDITOR="$VISUAL"
fi

# Golang project switch, requires `find-project`: github.com/patrickdappollonio/find-project
function gs() {
    if ! command -v find-project &>/dev/null; then
        echo "Install find-project first by running: go install github.com/patrickdappollonio/find-project@latest"
        return 1
    fi

    cd "$(find-project "$1")" || return
}

# Download projects by cloning them, requires `gc-rust`: github.com/patrickdappollonio/gc-rust
function gc() {
    if ! command -v gc-rust &>/dev/null; then
        echo "Install gc-rust first from github.com/patrickdappollonio/gc-rust"
        return 1
    fi

    cd "$(gc-rust "$@")" || return
}

# Alias cat to bat if it's installed
if command -v bat &>/dev/null; then
    alias cat='bat --style=numbers,changes,grid --paging=never'
fi

############################################################################
#                        KUBERNETES CONFIGURATIONS
############################################################################

# Automatically set kubeconfig env var
function change-k8() {
    # shellcheck disable=SC2012
    mapfile -t kks < <(ls -1 "$HOME/.kube/"*.yml 2>/dev/null | sed 's|.*/||')
    if [ "${#kks[@]}" -eq 0 ]; then
        echo "No kubeconfig files found in ~/.kube/"
        return 1
    fi

    echo "kubectl: select a kubeconfig file"

    PS3="Use number to select a file or 'stop' to cancel: "

    select filename in "${kks[@]}"; do
        if [[ "$REPLY" == "stop" ]]; then
            break
        fi

        if [[ -z "$filename" ]]; then
            echo "'$REPLY' is not a valid number"
            continue
        fi

        echo "kubectl config set to: $filename"
        export KUBECONFIG="$HOME/.kube/$filename"

        break
    done
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

# Enable kubectl autocompletion if kubectl is installed
if command -v kubectl &>/dev/null; then
    # shellcheck disable=SC1090
    source <(command kubectl completion bash)
fi

# Shorthand for terraform
alias tf='terraform'

# Create a temporary directory and cd into it
function td() {
    dir=$(mktemp -d "${GOPATH}/src/github.com/patrickdappollonio/temp-XXXXXX")
    mkdir -p "$dir" && cd "$dir" || return
}

# Delete all temp folders
function cleantd() {
    find "${GOPATH}/src/github.com/patrickdappollonio/" -maxdepth 1 -name "temp-*" -type d -not -path '*/\.*' -exec rm -rf {} +
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
            rm "$socket" 2>/dev/null
        fi
    done

    if [[ -z $WSL_INTEROP ]]; then
        echo -e "\033[31mNo working WSL_INTEROP socket found!\033[0m"
    fi
}

# Add a fix for WSL interop in VSCode from the terminal
if [ "$IS_WSL" = true ]; then
    function code() {
        wsl_interop
        command code "$@"
    }
fi

# Configure Colima if it exists
if [ -S "$HOME/.colima/default/docker.sock" ]; then
    export DOCKER_SOCK="unix://$HOME/.colima/default/docker.sock"
    export DOCKER_DEFAULT_PLATFORM=linux/amd64
fi

# Configure SSH agent
SSH_ENV="$HOME/.ssh/agent-environment"

function start_ssh_agent {
    echo "ℹ️ Starting new SSH agent..."
    (
        umask 077
        ssh-agent >"$SSH_ENV"
    )
    chmod 600 "$SSH_ENV"
    # shellcheck disable=SC1090
    source "$SSH_ENV" >/dev/null
    ssh-add
}

# Source SSH settings, if applicable
if [ -f "$SSH_ENV" ]; then
    # shellcheck disable=SC1090
    source "$SSH_ENV" >/dev/null
    # Check if the agent is still running
    if ! ps -p "$SSH_AGENT_PID" >/dev/null 2>&1; then
        start_ssh_agent
    fi
else
    start_ssh_agent
fi
