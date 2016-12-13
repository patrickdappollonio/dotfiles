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
export GOPATH=/home/marlex/Golang
export PATH=$PATH:$GOPATH/bin

# Other commonly used aliases
alias environ='subl ~/.bash_profile'
alias srcenv='source ~/.bash_profile'
alias gd='cd $HOME/Development'

# Pbcopy and pbpaste
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

# Golang switch, requires `find-project`: github.com/patrickdappollonio/find-project
function gs() {
   cd $(find-project $1)
}

# Disable screen flow control XON/XOFF
stty -ixon

# Source tty-specific settings
# source ~/.dotfiles/.bash_profile_tty

# Source HPE-specific settings
source ~/.dotfiles/.bash_profile_hpe
