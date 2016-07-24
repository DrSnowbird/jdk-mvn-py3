#!/bin/bash 

# Reference: https://docs.docker.com/engine/userguide/containers/dockerimages/

echo "Usage: "
echo "  ${0} <repo-name/repo-tag>"
echo
imageTag=${1:-openkbs/jre-mvn-py3}
#imageVersion=1.0.0

docker ps -a

containerID=`docker ps |grep "${imageTag}"|awk '{print $1}'`
echo "containerID=$containerID"

docker commit -m "initial image" ${containerID} ${imageTag}:$imageVersion
docker commit -m "initial image" ${containerID} ${imageTag}:latest

docker push ${imageTag}:$imageVersion
docker push ${imageTag}:latest

