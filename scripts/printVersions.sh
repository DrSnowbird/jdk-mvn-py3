#!/bin/bash -x

echo "JAVA_HOME=$JAVA_HOME"
whereis java
echo
java -version
mvn --version
python -V
python3 -V
pip --version
pip3 --version
gradle --version
npm -v
node -v
yarn -V
cat /etc/*-release

