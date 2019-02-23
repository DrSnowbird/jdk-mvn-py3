#!/bin/bash -x

##################################
## ---- user: developer ----
##################################

USER=${1:-developer}
HOME=/home/${USER}

sudo groupadd ${USER} && sudo useradd ${USER} -m -d ${HOME} -s /bin/bash -g ${USER} 

