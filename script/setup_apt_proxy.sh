#!/bin/bash -x

echo "####################### Components: $(basename $0) ###########################"

env | grep -i proxy

#### ---- Format (Ubuntu): /etc/apt/apt.conf Proxy Server URL ---- ####
#    Acquire::http::Proxy "http://user:pass@proxy_host:port";
# Other way:
#    sudo apt-get -o Acquire::http::proxy=false <update/install> 
#    sudo apt-get -o Acquire::http::proxy=http://proxy.openkbs.org:80/ <update/install> 

#APT_CONF=/etc/apt/apt.conf
APT_CONF=test_apt.conf

HAS_PROXY=0
function addProxyToAptConf() {
    if [ "${1}" != "" ]; then
        HAS_PROXY=1
        echo "Acquire::http::Proxy \"${1}\";" | sudo tee -a ${APT_CONF}
    fi
}
addProxyToAptConf ${http_proxy}

if [ $HAS_PROXY -gt 0 ]; then
    echo -e ">>>> $0: Found proxy environment vars setup found! \n Setup ${APT_CONF} for proxy servers URLs!"
    echo -e "--------- ${APT_CONF}: -------------\n"
    cat ${APT_CONF}
else
    echo -e ">>>> $0: No proxy vars setup found! \n No need to setup ${APT_CONF} for proxy servers URLs!"
fi
