# Find if it's linux what we are running
if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    IS_LINUX_OS=true
else
    IS_LINUX_OS=false
fi

# Add PS1
export PS1="\[\e[00;33m\]\u\[\e[0m\]\[\e[00;37m\]@\h \[\e[0m\]\[\e[01;36m\][\W]\$(__git_ps1)\[\e[0m\]\[\e[00;36m\]:\[\e[0m\]\[\e[00;37m\] \[\e[0m\]"

# Diverse aliases for my common tasks
alias ll='ls -aFhlG --color=auto'
alias ..='cd ..'
alias ...='cd ../..'

# Golang aliases
alias goi='go install'
alias gob='go build'

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
	alias pbcopy='xclip -selection clipboard'
	alias pbpaste='xclip -selection clipboard -o'
fi

# Open folders
if [ "$IS_LINUX_OS" = false ]; then
	alias open="start"
fi

# MKDir and CD
function mkcd() {
	mkdir -p $1 && cd $1
}

# Golang switch, requires `find-project`: github.com/patrickdappollonio/find-project
function gs() {
	if ! type "find-project" > /dev/null; then
		echo -e "Install find-project first by doing: go get -u -v github.com/patrickdappollonio/find-project"
		exit 1
	fi

	cd $(find-project $1)
}

# Go get with update and verbose
function gg() {
	go get -u -v $1
}

# Add git __git_ps1 prompt
source ~/.dotfiles/.git_sh

# Source HPE-specific settings
source ~/.dotfiles/.bash_profile_hpe