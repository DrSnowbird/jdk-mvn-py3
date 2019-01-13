#!/bin/bash -x

echo "JAVA_HOME=$JAVA_HOME"
java -version
mvn --version
python -V
python3 -V
pip --version
pip3 --version
gradle --version
npm --version
node --version
cat /etc/*-release

