#!/bin/bash

MY_DIR=$(dirname "$(readlink -f "$0")")

if [ $# -lt 3 ]; then
    echo "Usage: copy into docker or from docker"
    echo "  ${0} <direction: into/from> <local_full_filepapth or directory> <docker_full_filepath or directory>"
    echo "e.g.: "
    echo ">> To copy 'toos/cuda-torch-info.py' into remote/Docer's directory, /home/developer/tools_tmp/"
    echo "  ${0} into toos/cuda-torch-info.py /home/developer/tools_tmp "
    echo " "
    echo ">> To copy from remote/Docer's: /home/developer/tools/cuda-torch-info.py --> local's directory: toos_2/"
    echo "  ${0} from too_2 /home/developer/tools/cuda-torch-info.py "
    echo "-------- more examples: ---------"
    echo "./copy.sh from tools /home/developer/tools"
    echo "./copy.sh from tools_new /home/developer/tools"
    echo "./copy.sh from tools_new/nvidia-smi-query-info.sh /home/developer/tools5/nvidia-smi-query-info.sh"
    echo "./copy.sh from tools_new/nvidia-smi-query-info-NEW.sh /home/developer/tools5/nvidia-smi-query-info.sh"
    echo ""
    echo "./copy.sh into tools/nvidia-smi-query-info.sh /home/developer/"
    echo "./copy.sh into tools/nvidia-smi-query-info.sh /home/developer/tools_not_exist/"
    echo "./copy.sh into tools/nvidia-smi-query-info.sh /home/developer/tools/nvidia-smi-query-info-NEW.sh"
    echo "./copy.sh into tools/nvidia-smi-query-info.sh /home/developer/tools_not_exist/nvidia-smi-query-info-NEW.sh"
echo ""

    exit 1
fi

direction="${1,,}"
if [ "${direction}" != "into" ] && [ "${direction}" != "from" ]; then
    echo ">>> ERROR: ${1}: is not acceptable!"
    echo ">>> Only 'into' or 'from' is acceptable!"
    echo "..."
    exit 1
fi

###################################################
#### ---- Change this only to use your own ----
###################################################
ORGANIZATION=openkbs
baseDataFolder="$HOME/data-docker"

###################################################
#### **** Container package information ****
###################################################
DOCKER_IMAGE_REPO=`echo $(basename $PWD)|tr '[:upper:]' '[:lower:]'|tr "/: " "_" `
imageTag="${ORGANIZATION}/${DOCKER_IMAGE_REPO}"

## -- transform '-' and space to '_' 
#instanceName=`echo $(basename ${imageTag})|tr '[:upper:]' '[:lower:]'|tr "/\-: " "_"`
instanceName=`echo $(basename ${imageTag})|tr '[:upper:]' '[:lower:]'|tr "/: " "_"`

container_id=`docker ps |grep ${instanceName}|awk '{print $1}'`

echo "---------------------------------------------"
echo "---- shell into the Container for ${imageTag}"
echo "---------------------------------------------"

function copy() {
    local_fpath=$2
    remote_fpath=$3
    if [ "${direction}" == "into" ]; then
        echo ">>> INFO: copy direction: from Local to Remote/Docker ..."
        if [ -d "${local_fpath}" ]; then
            echo ">>> 1-A)INFO: local filepath: ${local_fpath} is a directory! ..."
            echo ">>> 1-A) ... checking/finding remote/Docker's filepath as directory: ${remote_fpath} ..."
            docker_path_check=`./shell.sh "ls -al ${remote_fpath}" | grep "No such" `
            if [ "${docker_path_check}" != "" ]; then
                echo ">>> 1-B-1) INFO: Create remote/Docker's directory: ${remote_fpath} ..."
                ./shell.sh "mkdir -p ${remote_fpath}"
            else
                echo -e "1-B-2) remote: exists! It must be a directory for copying dir-to-dir to work!"
                docker_dir_check=`./shell.sh "ls -al ${remote_fpath}" | grep -v "^---" | grep "^d" `
                if [ "${docker_dir_check}" != "" ]; then
                    echo ">>> INFO: Remote/Docker filepath: ${remote_fpath} is an existing directory ..."
                else
                    # -- remote: check if it is a file -- #
                    docker_file_check=`./shell.sh "ls -al ${remote_fpath}" | grep -v "^---" | grep -v "^d" `
                    if [ "${docker_file_check}" != "" ]; then
                        echo ">>> 1-B-2-A) ERROR: Remote/Docker filepath is NOT a directory! Abort!"
                        echo " "
                        exit 1
                    fi
                fi
            fi
            echo -e ">>> 1-C-3) ... copy file to file: ${remote_fpath} ..."
            ## -- Start dir-to-dir copy: -- ##
            for f in `ls ${local_fpath}`; do
                docker cp ${local_fpath}/$f ${container_id}:${remote_fpath}
            done
        else
            echo -e ">>> 1-B) ... copy file to file: ${remote_fpath} ..."
            filename=$(basename -- "${remote_fpath}")
            extension="${filename##*.}"
            filename="${filename%.*}"
            if [ "$extension" == "" ]; then
                echo ">>> 1-B-1) ... copy a file to remote/Docker's directory (may not exits yet)"
                echo ">>> 1-B-1) INFO: Create remote/Docker's directory: ${remote_fpath} ..."
                ./shell.sh "mkdir -p ${remote_fpath}"
            fi
            docker cp ${local_fpath} ${container_id}:${remote_fpath}
        fi
    elif [ "${direction}" == "from" ]; then
        echo ">>> INFO: copy direction: from Remote/Docker ... to Local ..."
        docker_path_check=`./shell.sh "ls -al ${remote_fpath}" | grep "No such" `
        if [ "${docker_path_check}" != "" ]; then
            echo ">>> 2-A) ERROR: Remote/Docker filepath is NOT existing! Abort!"
            echo " "
            exit 1
        else
            echo ">>> 2-A) INFO: Remote/Docker filespath exists! Continue!"
        fi
        docker_dir_check=`./shell.sh "ls -al ${remote_fpath}" | grep -v "^---" | grep "^d" `
        docker_file_check=`./shell.sh "ls -al ${remote_fpath}" | grep -v "^---" | grep -v "^d" `
        if [ "${docker_dir_check}" != "" ]; then
            echo ">>> 2-B-1) ... Remote/Docker's filepath is a directory: ${remote_fpath} ..."
            
            ## -- remote/Docker filepath is a directory: -- ##
            if [ -f ${local_fpath} ]; then
                echo ">>> 2-B-2-A) ERROR: local filepath: ${local_fpath} is an existing file! Abort!"
                echo ""
                exit 1
            fi
            if [ ! -d ${local_fpath} ]; then
                echo ">>> 2-B-3-A) ... Local directory not existing! Create a directory: ${local_fpath} ..."
                mkdir -p ${local_fpath}
            fi
            echo ">>> 2-B-3) ... ready to copy Remote/Docker's directory to local directory: ${local_fpath}  ..."
            docker_files=`./shell.sh ls ${remote_fpath} | grep -v "^---" | tr -d '\r'`
            echo ">>> INFO: $docker_files"
            
            for f in ${docker_files}; do
                docker cp ${container_id}:${remote_fpath}/${f} ${local_fpath}
            done
        else
            filename=$(basename -- "${local_fpath}")
            extension="${filename##*.}"
            filename="${filename%.*}"
            if [ "$extension" == "" ]; then
                echo ">>> 2-B-1) ... copy a remote/Docker's file to local directory (not exits yet)"
                echo ">>> 2-B-1) INFO: Create remote/Docker's directory: ${remote_fpath} ..."
                mkdir -p ${local_fpath}
            fi
            echo ">>> 2-B-2) ... copy remote/Docker's file to local file/directory ..."
            docker cp ${container_id}:${remote_fpath} ${local_fpath}
        fi
        
    else
        echo ">>> ERROR: ${1}: is not acceptable!"
        echo ">>> Only 'into' or 'from' is acceptable!"
        echo "..."
    fi
}

copy ${direction} $2 $3
