#!/bin/bash -x

echo "####################### Components: $(basename $0) ###########################"

env | grep -i proxy

HAS_PROXY=0
function setupNpmProxy() {
    if [ "${1}" != "" ]; then
        /usr/bin/npm config set proxy ${http_proxy} && \
        /usr/bin/npm config set http_proxy ${http_proxy} && \
        /usr/bin/npm config set https_proxy ${https_proxy}
    fi
}
setupNpmProxy ${http_proxy}

if [ $HAS_PROXY -gt 0 ]; then
    echo -e ">>>> $0: Found proxy environment vars setup found! \n Setup NPM for proxy servers URLs!"
    echo -e "--------- ${APT_CONF}: -------------\n"
    cat ${APT_CONF}
else
    echo -e ">>>> $0: No proxy vars setup found! \n No need to setup NPM for proxy servers URLs!"
fi
