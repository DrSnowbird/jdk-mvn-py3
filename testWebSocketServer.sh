#!/bin/bash

SCRIPT_FILE=WebSocketServer.js
HOST_PORT=8080

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

mkdir -p ./data

# To run: nodejs ./WebSocketServer.js
# Then => Open http://localhost:8080/
# To see: Hello World!

cat > ./data/${SCRIPT_FILE} <<'EOF'
const WebSocket = require('ws');
 
const wss = new WebSocket.Server({ port: 8080 , host : '0.0.0.0'});
 
wss.on('connection', function connection(ws) {
  ws.on('message', function incoming(message) {
    console.log('received: %s', message);
  });
 
  ws.send('something');
});
var WebSocketServer = require('ws').Server;
var wss = new WebSocketServer({ port: 8080, host : '0.0.0.0' });

wss.on('connection', function connection(ws) {
    console.log('Server WebSocket was connected.');

    ws.on('message', function incoming(message) {
        console.log('received: %s', message);
    });

    ws.send('Hello World from openkbs/jdk-mvn-py3 with WebSocket in NodeJS supports! \n See https://github.com/DrSnowbird/jdk-mvn-py3 \n');
    
    ws.on('close', function () {
        console.log('websocket connection closed!');
    });

});

EOF

TIMEOUT_SEC=20

echo
echo "----------------------------------------------------------------------"
echo "Starting JavaScript NodeJS mini-webserver:"
echo "You have $TIMEOUT_SEC to test this NodeJS mini-server."
echo "... then, it will destroy itself (like 007 Bond's movie - self-clean up :-) "
echo "----------------------------------------------------------------------"
echo "---> Open your browser to : http://127.0.0.1:${HOST_PORT}/"
echo "---> Or, command line:"
echo "        curl http://localhost:${HOST_PORT}/"
echo "        curl http://127.0.0.1:${HOST_PORT}/"
echo
docker run -d --rm --name ${instanceName} -v $PWD/data:/data -p ${HOST_PORT}:3000 --workdir /data openkbs/jdk-mvn-py3 nodejs /data/${SCRIPT_FILE}

echo "---> Testing the mini-server by the WebSocketServer.js script:"
echo
echo "---> 1.) curl GET http://127.0.0.1:${HOST_PORT}/"
curl -s GET http://127.0.0.1:${HOST_PORT}/
echo
echo "---> 2.) curl http://127.0.0.1:${HOST_PORT}/"
curl -s http://127.0.0.1:${HOST_PORT}/
echo
echo "---> 3.) curl http://localhost:${HOST_PORT}/"
curl -s http://localhost:${HOST_PORT}/

echo "... You have $TIMEOUT_SEC seconds to try out the above URL provided by JavaScript as Web Servers."
sleep $TIMEOUT_SEC

cleanup


