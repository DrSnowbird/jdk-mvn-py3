#!/bin/bash

echo "JAVA_HOME=$JAVA_HOME"
whereis java
echo
which java && java -version
which mvn && mvn --version
which python && python -V
which python3 && python3 -V
which pip && pip --version
which pip3 && pip3 --version
which gradle && gradle --version
which npm && npm -v
which node && node -v
cat /etc/*-release
which ant && ant -version 
