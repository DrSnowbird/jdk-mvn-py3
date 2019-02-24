#!/bin/bash -x

echo "####################### Components: $(basename $0) ###########################"

whoami

id

env

for pkg in `cat ${SCRIPT_DIR}/requirements-npm.txt`; do
    npm install -g $pkg
done
