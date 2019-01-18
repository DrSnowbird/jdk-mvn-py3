#!/bin/bash -x

###################################################
#### ---- Change this only if want to use your own
###################################################
ORGANIZATION=openkbs

###################################################
#### ---- Container package information ----
###################################################
DOCKER_IMAGE_REPO=`echo $(basename $PWD)|tr '[:upper:]' '[:lower:]'|tr "/: " "_" `
imageTag=${1:-"${ORGANIZATION}/${DOCKER_IMAGE_REPO}"}

mkdir -p ./data

# To run: nodejs ./simple-server.js
# Then => Open http://localhost:3000/
# To see: Hello World!

cat > ./data/SimpleServer.js <<'EOF'
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

cat ./data/SimpleServer.js

echo "Open your browser to : http://0.0.0.0:3000/"

docker run -d --name some-jdk-mvn-py3 -v $PWD/data:/data -p 3000:3000 --workdir /data openkbs/jdk-mvn-py3 nodejs /data/SimpleServer.js



