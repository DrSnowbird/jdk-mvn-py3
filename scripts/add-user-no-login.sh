#!/bin/bash -x

#############################################################
#### ---- user: no login (e.g. ftp, or application) ---- ####
#############################################################
# ref: https://www.cyberciti.biz/tips/bash-shell-parameter-substitution-2.html

# Usage : Add a no-login user
USER_NAME=${1:-developer}
USER_PASSWORD="${2:-ChangeMeNow!}"
 
# die if username/password not provided
[ $# -ne 2 ] && { echo "Usage: <username> <password>"; exit 1; }
 
# Get username length and make sure it always <= 8
[[ ${#USER_NAME} -ge 9 ]] && { echo "Error: Username should be maximum 8 characters in length. "; exit 2; }
 
# Check for existing user in /etc/passwd
/usr/bin/getent passwd "${USER_NAME}" &>/dev/null
 
# Check exit status
[ $? -eq 0 ] && { echo "Error: username \"${USER_NAME}\" exists."; exit 3; }
 
# Add user
sudo useradd ${USER_NAME} -s /usr/sbin/nologin -m -p $(echo ${USER_PASSWD} | openssl passwd -1 -stdin) 


