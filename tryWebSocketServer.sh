#!/bin/bash

SCRIPT_FILE=WebSocketServer.js
HOST_PORT=8080
SERVER_PORT=8080

TIMEOUT_SEC=40

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

const WebSocketServer = require('ws').Server;
const wss = new WebSocketServer({ port: 8080, host : '0.0.0.0' });

// -- connection --
wss.on('connection', function connection(ws) {
    const ip = ws._socket.remoteAddress;
    console.log('Server WebSocket was connected from: ' + ip);
    ws.send('... Hello World from openkbs/jdk-mvn-py3 with WebSocket in NodeJS supports! \n... See https://github.com/DrSnowbird/jdk-mvn-py3 for more information.\n');

    // -- open --
    ws.on('open', function open() {
        console.log('connected');
        ws.send('time (open): ' + Date.now());
    });

    // -- message --
    ws.on('message', function incoming(data) {
        // console.log(`Roundtrip time: ${Date.now() - data} ms`);
        ws.send('message: ' + data + ', received by Server at:' + Date.now());
        console.log('message: ' + data + ', received by Server at:' + Date.now());

        // setTimeout(function timeout() {
        //     console.log('setTimeout at:' + Date.now());
        //     ws.send('setTimeout at: ' + Date.now());
        // }, 500);
    });

    // -- close --
    ws.on('close', function close() {
        console.log('time (close) at:' + Date.now());
        console.log('disconnected');
    });

});

EOF

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
docker run -d --rm --name ${instanceName} -v $PWD/data:/data -p ${HOST_PORT}:${SERVER_PORT} --workdir /data openkbs/jdk-mvn-py3 nodejs /data/${SCRIPT_FILE}

echo "---> Testing the mini-server by the ${SCRIPT_FILE} script:"
echo "Use Web Socket Client, e.g., Chrome plugins, WebSocketTestClient, SimpleWebSocketClient in brwoser to test:"
echo "For example,"
echo "   echo \"Some data to be sent\" | websocat ws://127.0.0.1:${HOST_PORT} "
echo ""
echo "Obviously, there are also alternatives like wscat (golang) or wscat (node)."

echo "... You have $TIMEOUT_SEC seconds to try out the above URL provided by JavaScript as Web Servers."
sleep $TIMEOUT_SEC

cleanup


