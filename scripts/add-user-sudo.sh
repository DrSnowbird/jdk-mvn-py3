#!/bin/bash -x

##################################
## ---- user: developer ----
##################################

if [ $# -lt 1 ]; then
    echo "**** Usage: $(basename $0 <user_name> [,user_password>]) "
    echo "**** ERROR: Need at lease <user_name> as argument. !"
    echo "Abort!"
    echo
    exit 1;
fi

USER_NAME=${1:-developer}
USER_PASSWORD=${2}

HOME=/home/${USER_NAME}

if [ "$USER_PASSWORD" != "" ]; then
    sudo groupadd ${USER_NAME}
    sudo useradd ${USER_NAME} -m -d ${HOME} -s /bin/bash -g ${USER_NAME} -p $(echo ${USER_PASSWORD} | openssl passwd -1 -stdin) 
else
    sudo groupadd ${USER_NAME} && sudo useradd ${USER_NAME} -m -d ${HOME} -s /bin/bash -g ${USER_NAME}
fi

exit 1

#echo "${USER_NAME} ALL=NOPASSWD:ALL" | sudo tee -a /etc/sudoers
sudo usermod -aG sudo ${USER_NAME}

