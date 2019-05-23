#!/bin/bash -x

echo "####################### Components: $(basename $0) ###########################"

whoami

id

env

for pkg in `cat ${SCRIPT_DIR}/requirements-npm.txt | grep -v '^#'`; do
    npm install $pkg
done
