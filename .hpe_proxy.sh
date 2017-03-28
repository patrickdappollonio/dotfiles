####################
#   HPE SPECIFIC   #
####################

# Corporate proxy
CORP_PROXY_HOST="web-proxy.houston.hpecorp.net"
CORP_PROXY_PORT="8080"
CORP_PROXY="$CORP_PROXY_HOST:$CORP_PROXY_PORT"

# Find if it's linux what we are running
if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    IS_LINUX_OS=true
else
    IS_LINUX_OS=false
fi

# Find if it's on the HPE network
if [ "$IS_LINUX_OS" = false ] && [ "$(ipconfig | grep -m 1 Suffix | awk '{ print $NF }')" == "americas.hpqcorp.net" ]; then
    IS_HPE_NETWORK=true
elif [ "$IS_LINUX_OS" = true ] && [ "$(hostname -I | awk -F '.' '{ print $1  }')" == "10" ]; then
    IS_HPE_NETWORK=true
elif [ "$IS_LINUX_OS" = true ] && [ "$(hostname -I | awk -F '.' '{ print $1  }')" == "172" ]; then
    IS_HPE_NETWORK=true
else
    IS_HPE_NETWORK=false
fi

# configure proxy for git while on corporate network
function proxy_on(){
    # on Windows env vars are UPPERCASE even in git bash
    export HTTP_PROXY="http://$CORP_PROXY/"
    export HTTPS_PROXY="https://$CORP_PROXY/"
    export http_proxy=$HTTP_PROXY
    export https_proxy=$HTTPS_PROXY

    # Additionals for FTP and ALL (needed in some environments)
    export {FTP,ALL}_PROXY="$CORP_PROXY"
    export {ftp,all}_proxy="$CORP_PROXY"

    export NO_PROXY="localhost,127.0.0.1,$USERDNSDOMAIN,192.168.99.100"

    # internal CA certificate in corporate environment
    export GIT_SSL_NO_VERIFY=1

    # check if it's Linux OS
    if [ "$IS_LINUX_OS" = true ] && [ ! -z `which gsettings` ]; then
        gsettings set org.gnome.system.proxy mode "manual";
        gsettings set org.gnome.system.proxy.http host "$CORP_PROXY_HOST";
        gsettings set org.gnome.system.proxy.http port "$CORP_PROXY_PORT";
    fi

    # env | grep -e _PROXY -e GIT_ | sort
    echo -e "Proxy-related environment variables set."
}

# remove proxy settings when off corporate network
function proxy_off(){
    local variables=( \
        "PASSWORD" "PROXY_SERVER" "PROXY_PORT" \
        "HTTP_PROXY" "HTTPS_PROXY" "FTP_PROXY" "ALL_PROXY" \
        "http_proxy" "https_proxy" "ftp_proxy" "all_proxy" \
        "NO_PROXY" "GIT_CURL_VERBOSE" "GIT_SSL_NO_VERIFY" \
        )

    for i in "${variables[@]}"
    do
        unset $i
    done

    # check if it's Linux OS
    if [ "$IS_LINUX_OS" = true ] && [ ! -z `which gsettings` ]; then
        gsettings set org.gnome.system.proxy mode "none";
    fi

    echo -e "Proxy-related environment variables removed."
}

function sudo_env() {
    if sudo grep -q "# Keep" /etc/sudoers ; then
        echo -e "Politely refusing to add env vars to sudoers: vars already exists."
        return
    fi

    local variables=( \
        "PASSWORD" "PROXY_SERVER" "PROXY_PORT" \
        "HTTP_PROXY" "HTTPS_PROXY" "FTP_PROXY" "ALL_PROXY" \
        "http_proxy" "https_proxy" "ftp_proxy" "all_proxy" \
        "NO_PROXY" "GIT_CURL_VERBOSE" "GIT_SSL_NO_VERIFY" \
        "GOPATH" "GOBIN" "PATH" \  # Go-specific paths
    )

    local data=()

    for i in "${variables[@]}"
    do
        if [ ! -z "${i// }" ]; then
            data+=("$i")
        fi
    done

    local content='Defaults env_keep += "'"${data[@]}"'"'

    sudo bash -c "echo ' ' | (EDITOR='tee -a' visudo)"
    sudo bash -c "echo '# Keep environment variables' | (EDITOR='tee -a' visudo)"
    sudo bash -c "echo '$content' | (EDITOR='tee -a' visudo)"
}

function sudo() {
    echo -e "\033[1m Invoking sudo with all current environment variables.\033[0m"
    command sudo -E "$@"
}

function dockerb() {
    echo -e "\033[1m Invoking docker build with pull=true and rm=true with environment.\033[0m"
    docker build --pull=true --rm=true -t $1 . \
        --build-arg http_proxy=$HTTP_PROXY \
        --build-arg https_proxy=$HTTPS_PROXY \
        --build-arg HTTP_PROXY=$HTTP_PROXY \
        --build-arg HTTPS_PROXY=$HTTPS_PROXY
}

# This enables proxy by default every time the shell opens
# to disable, just run "proxy_off"
if [ "$IS_HPE_NETWORK" = true ]; then
    proxy_on
fi

# Workaround fix for ansible-galaxy command taking https proxy
# and assumming is http
function ansible-galaxy() {
    export https_proxy=$HTTP_PROXY
    command ansible-galaxy "$@"
    export https_proxy=$HTTPS_PROXY
}
