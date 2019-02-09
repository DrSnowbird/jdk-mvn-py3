#!/bin/bash -x

echo "####################### Components: $(basename $0) ###########################"

echo ">>>> Who am i: `whoami` ; UID=`id -u` ; GID=`id -g`"

#### ---- Setup NPM with permission so that no "sudo" required to install NPM Packages ----

# 1) Set yourself as an owner of ~/.npm directory, like this:
#if [ ! -d ${HOME}/.npm ]; then
#    mkdir -p ${HOME}/.npm
#fi
#chown -R $(whoami) ${HOME}/.npm

# 2.) and if error persists, set yourself as an owner /usr/local/lib/node_modules directory too, like this:
if [ ! -d /usr/local/lib/node_modules ]; then
    mkdir -p /usr/local/lib/node_modules
fi
chown -R $(whoami) /usr/local/lib/node_modules
