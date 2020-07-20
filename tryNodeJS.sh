#!/bin/bash

SCRIPT_FILE=SimpleServer.js
HOST_PORT=3000
SERVER_PORT=3000

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

# To run: nodejs ./SimpleServer.js
# Then => Open http://localhost:3000/
# To see: Hello World!

cat > ./data/${SCRIPT_FILE} <<'EOF'
const http = require('http');

const hostname = '0.0.0.0';
const port = 3000;

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello World from openkbs/jdk-mvn-py3 with NodeJS supports! \n See https://github.com/DrSnowbird/jdk-mvn-py3 \n');
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
EOF

# cat ./data/${SCRIPT_FILE}

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
docker run -d --rm --name ${instanceName} -v $PWD/data:/data -p ${HOST_PORT}:${SERVER_PORT} --workdir /data openkbs/jdk-mvn-py3 node /data/${SCRIPT_FILE}

echo "---> Testing the mini-server by the ${SCRIPT_FILE} script:"
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


