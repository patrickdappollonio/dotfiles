#!/bin/bash
set -euo pipefail

# Find if it's linux what we are running
export VERSION=$(lsb_release -sc)
export CODENAME=$(lsb_release -sr)

# Run the actual command
which tmux >/dev/null 2>&1 && { tmux attach || tmux new -s $VERSION-${CODENAME//./};  } || bash -l
