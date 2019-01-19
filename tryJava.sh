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

instanceName=some-jdk-mvn-py3
function cleanup() {
    if [ ! "`docker ps -a|grep ${instanceName}`" == "" ]; then
         docker rm -f ${instanceName}
    fi
}

mkdir -p ./data
mkdir -p ./data
cat >./data/HelloWorld.java <<-EOF
public class HelloWorld {
   public static void main(String[] args) {
      System.out.println("Hello, World");
   }
}
EOF
cat ./data/HelloWorld.java
djavac='docker run -it --rm -v '$PWD'/data:/data --workdir /data '${imageTag}' javac'
djava='docker run -it --rm -v '$PWD'/data:/data --workdir /data '${imageTag}' java'

echo
echo "----------------------------------------------------------------------"
echo "1.) Compile HelloWorld.java in Guest's workdir /data: "
echo "docker run -it --rm -v $PWD/data:/data --workdir /data openkbs/jdk-mvn-py3 javac HelloWorld.java"
$djavac HelloWorld.java

echo
echo "----------------------------------------------------------------------"
echo "2.) Run HelloWorld.class in Guest's workdir /data: "
echo "docker run -it --rm -v $PWD/data:/data --workdir /data openkbs/jdk-mvn-py3 java HelloWorld"
$djava HelloWorld


