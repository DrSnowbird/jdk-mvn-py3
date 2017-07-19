#!/bin/bash 

docker run -it --rm openkbs/jre-mvn-py3 python3 -c 'print("Hello World")'

docker run --rm openkbs/jre-mvn-py3 python3 -c 'print("Hello World")'

mkdir -p ./data
echo "print('Hello World')" > ./data/myPyScript.py

docker run -it --rm --name some-jre-mvn-py3 -v "$PWD"/data:/data openkbs/jre-mvn-py3 python3 myPyScript.py

docker run -i --rm openkbs/jre-mvn-py3 python3 < ./data/myPyScript.py


