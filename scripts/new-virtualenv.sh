#!/bin/bash -x

pip --no-cache-dir install --user --upgrade virtualenv
pip --no-cache-dir install --user --upgrade virtualenvwrapper
pip --no-cache-dir install --user https://github.com/pypa/virtualenv/tarball/master

PROG_NAME=$(basename $0)
function usage() {
    echo "$PROG_NAME <new_Virtualenv_project_folder>"
    echo "See https://virtualenvwrapper.readthedocs.io/en/latest/ for more information & guide"
}
usage

PROJ_DIR=${1:-"`pwd`/env`date +%Y-%m-%d`"}
export WORKON_HOME=~/Envs
mkdir -p $WORKON_HOME
source /usr/local/bin/virtualenvwrapper.sh
mkvirtualenv ${PROJ_DIR}
