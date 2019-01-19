#!/bin/bash 

###################################################
#### ---- Change this only if want to use your own
###################################################
ORGANIZATION=openkbs

###################################################
#### ---- Container package information ----
###################################################
DOCKER_IMAGE_REPO=`echo $(basename $PWD)|tr '[:upper:]' '[:lower:]'|tr "/: " "_" `
imageTag=${1:-"${ORGANIZATION}/${DOCKER_IMAGE_REPO}"}

echo
echo "----------------------------------------------------------------------"
echo "1.) Way-1: Run python3 with command line: Hello World (command line):"
docker run --rm ${imageTag} python3 -c 'print("Hello World (command line) from ./tryPython.sh")'

mkdir -p ./data
echo "print('Hello World (./data/myPyScript.py) from ./tryPython.sh')" > ./data/myPyScript.py

echo
echo "----------------------------------------------------------------------"
echo "2.) Way-2: Run python3 /data/myPyScript.py:"
echo "docker run --rm -v "$PWD"/data:/data --workdir /data ${imageTag} python3 myPyScript.py"
docker run --rm -v "$PWD"/data:/data --workdir /data ${imageTag} python3 myPyScript.py

echo
echo "----------------------------------------------------------------------"
echo "3.) Way-3: Pipe file host's current data directory ./data/myPyScript.py into python3:"
echo "docker run --rm --workdir /data ${imageTag} python3 < ./data/myPyScript.py"
docker run --rm --workdir /data ${imageTag} python3 < ./data/myPyScript.py

