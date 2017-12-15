#!/bin/bash 

docker run -it --rm openkbs/jdk-mvn-py3 python3 -c 'print("Hello World")'

docker run --rm openkbs/jdk-mvn-py3 python3 -c 'print("Hello World")'

mkdir -p ./data
echo "print('Hello World')" > ./data/myPyScript.py

docker run -it --rm --name some-jdk-mvn-py3 -v "$PWD"/data:/data openkbs/jdk-mvn-py3 python3 myPyScript.py

docker run -i --rm openkbs/jdk-mvn-py3 python3 < ./data/myPyScript.py


