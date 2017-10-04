#!/bin/bash

# Find if it's linux what we are running
version=""
codename=""
if ! [ -x "$(command -v lsb_release)" ]; then
    version=$(cat /etc/system-release-cpe | awk -F: '{ print $3 }')
    codename=$(cat /etc/system-release-cpe | awk -F: '{ print $5 }' | grep -o ^[0-9]*)
else
    version=$(lsb_release -sc)
    codename=$(lsb_release -sr)
fi

export VERSION=$version
export CODENAME=$codename

# Run the actual command
which tmux >/dev/null 2>&1 && { tmux attach || tmux new -s $VERSION-${CODENAME//./};  }
