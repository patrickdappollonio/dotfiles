# Enable support for 256-colors
if [[ $TERM == xterm ]]; then TERM=xterm-256color; fi

# Export as TTY, since we're using a remote connection
# to an SSH Server
export GPG_TTY=`tty`

# Aliases, since I may forget it
alias subl=vim
alias gpom='git push origin master'

# Enable a 256-color term if possible
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
   export TERM='xterm-256color'
else
   export TERM='xterm-color'
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
export GOPATH=/home/marlex/Golang
export PATH=$PATH:$GOPATH/bin

# Other commonly used aliases
alias environ='subl ~/.bash_profile'
alias srcenv='source ~/.bash_profile'
alias gd='cd $HOME/Development'

# Golang switch, requires `find-project`: github.com/patrickdappollonio/find-project
function gs() {
   cd $(find-project $1)
}


####################
#   HPE SPECIFIC   #
####################

# configure proxy for git while on corporate network
function proxy_on(){
   # on Windows env vars are UPPERCASE even in git bash
   export HTTP_PROXY="web-proxy.houston.hpecorp.net:8080"
   export HTTPS_PROXY=$HTTP_PROXY
   export FTP_PROXY=$HTTP_PROXY
   export ALL_PROXY=$HTTP_PROXY # for SOCKS use ALL_PROXY or SOCKS_PROXY?

   export NO_PROXY="localhost,127.0.0.1,$USERDNSDOMAIN,192.168.99.100"

   # optional for debugging
   export GIT_CURL_VERBOSE=1

   # optional Self Signed SSL certs and
   # internal CA certificate in an corporate environment
   export GIT_SSL_NO_VERIFY=1

   # env | grep -e _PROXY -e GIT_ | sort
   echo -e "Proxy-related environment variables set."
}

# remove proxy settings when off corporate network
function proxy_off(){
   variables=( \
      "PASSWORD" "PROXY_SERVER" "PROXY_PORT" \
      "HTTP_PROXY" "HTTPS_PROXY" "FTP_PROXY" "ALL_PROXY" \
      "NO_PROXY" "GIT_CURL_VERBOSE" "GIT_SSL_NO_VERIFY" \
   )

   for i in "${variables[@]}"
   do
      unset $i
   done

   # env | grep -e _PROXY -e GIT_ | sort
   echo -e "Proxy-related environment variables removed."
}

# This enables proxy by default every time the shell opens
# to disable, just run "proxy_off"
proxy_on
