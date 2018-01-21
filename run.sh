#!/bin/bash 

# Reference: https://docs.docker.com/engine/userguide/containers/dockerimages/

echo "Usage: "
echo "  ${0} <repo-name/repo-tag>"
echo

###################################################
#### ---- Change this only if want to use your own
###################################################
ORGANIZATION=openkbs

###################################################
#### ---- Container package information ----
###################################################
DOCKER_IMAGE_REPO=`echo $(basename $PWD)|tr '[:upper:]' '[:lower:]'|tr "/: " "_" `
imageTag=${1:-"${ORGANIZATION}/${DOCKER_IMAGE_REPO}"}

version=

#instanceName=my-${2:-${imageTag%/*}}_$RANDOM
instanceName=my-${2:-${imageTag##*/}}

mkdir -p ./data

echo "(example)"
echo "docker run -d --name some-${imageTag##*/} -v $PWD/data:/data -i -t ${imageTag}"
if [ ! "$version" == "" ]; then
    docker run -d --name ${instanceName} -v $PWD/data:/data -t ${imageTag}:${version}
else
    docker run -d --name ${instanceName} -v $PWD/data:/data -t ${imageTag}
fi

echo ">>> Docker Status"
docker ps -a
echo "-----------------------------------------------"
echo ">>> Docker Shell into Container `docker ps -lq`"
docker exec -it ${instanceName} /bin/bash

