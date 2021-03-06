#!/bin/bash

# Disable Ctrl+S and Ctrl+Q
stty -ixon

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

# Check if tmux is installed
if ! [ -x "$(command -v tmux)" ]; then
    echo "Tmux needs to be installed in order for this to run!"
    read -p "Press enter to continue"
    exit 0
fi

# Run the actual command
which tmux >/dev/null 2>&1 && { tmux -2 new -A -s $VERSION-${CODENAME//./};  }
