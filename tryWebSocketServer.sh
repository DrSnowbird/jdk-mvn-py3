#!/bin/bash -x

SCRIPT_FILE=/home/developer/data/examples/ws-echo-server.js

HOST_PORT=8080
SERVER_PORT=8080

TIMEOUT_SEC=120

###################################################
#### ---- Change this only if want to use your own
###################################################
ORGANIZATION=openkbs

###################################################
#### ---- Container package information ----
###################################################
DOCKER_IMAGE_REPO=`echo $(basename $PWD)|tr '[:upper:]' '[:lower:]'|tr "/: " "_" `
imageTag=${1:-"${ORGANIZATION}/${DOCKER_IMAGE_REPO}"}

###################################################
#### ---- Mostly, you don't need change below ----
###################################################
instanceName=some-jdk-mvn-py3
function cleanup() {
    if [ ! "`docker ps -a|grep ${instanceName}`" == "" ]; then
         docker rm -f ${instanceName}
    fi
}
cleanup

#if [ ! -s ./data ]; then
#    mkdir -p ./data
#fi

echo "---> Testing the mini-server by the ${SCRIPT_FILE} script:"
echo "---> run the ws-client.js program:"
echo ".... Open an other XTERM console with the current same directory:"
echo ".... then run the command below to see the Client/Server messages"
echo "   node examples/ws-client.js"
echo

echo ".... Starting websocket echo server ....."
echo

./run.sh node ${SCRIPT_FILE}
#./run.sh node /home/developer/data/examples/ws-echo-server.js

