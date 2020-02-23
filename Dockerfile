FROM ubuntu

MAINTAINER openkbs.org@gmail.com

ENV DEBIAN_FRONTEND noninteractive

ENV JAVA_VERSION=8
#ENV JAVA_VERSION=11

##############################################
#### ---- Installation Directories   ---- ####
##############################################
ENV INSTALL_DIR=${INSTALL_DIR:-/usr}
ENV SCRIPT_DIR=${SCRIPT_DIR:-$INSTALL_DIR/scripts}

##############################################
#### ---- Corporate Proxy Auto Setup ---- ####
##############################################
#### ---- Transfer setup ---- ####
COPY ./scripts ${SCRIPT_DIR}
RUN chmod +x ${SCRIPT_DIR}/*.sh

#### ---- Apt Proxy & NPM Proxy & NPM Permission setup if detected: ---- ####
RUN cd ${SCRIPT_DIR}; ${SCRIPT_DIR}/setup_system_proxy.sh

########################################
#### update ubuntu and Install Python 3
########################################
RUN apt-get update -y && \
    apt-get install -y apt-utils automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev && \
    apt-get install -y curl iputils-ping nmap net-tools build-essential software-properties-common libsqlite3-dev sqlite3 bzip2 libbz2-dev git wget unzip vim python3-pip python3-setuptools python3-dev python3-venv python3-numpy python3-scipy python3-pandas python3-matplotlib && \
    apt-get install -y git xz-utils && \
    apt-get install -y sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

########################################
#### ------- OpenJDK Installation ------
########################################
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# A few reasons for installing distribution-provided OpenJDK:
#
#  1. Oracle.  Licensing prevents us from redistributing the official JDK.
#
#  2. Compiling OpenJDK also requires the JDK to be installed, and it gets
#     really hairy.
#
#     For some sample build times, see Debian's buildd logs:
#       https://buildd.debian.org/status/logs.php?pkg=openjdk-8

RUN apt-get update && apt-get install -y --no-install-recommends \
		bzip2 \
		unzip \
		xz-utils \
	&& rm -rf /var/lib/apt/lists/*

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# source: https://packages.debian.org/source/sid/openjdk-8
# source: https://packages.debian.org/source/sid/openjdk-11
# http://archive.ubuntu.com/ubuntu/pool/universe/o/openjdk-8/openjdk-8-jdk_8u232-b09-0ubuntu1~18.04.1_amd64.deb
ENV JAVA_DEBIAN_VERSION=8u232-b09-0ubuntu1~18.04.1

ENV JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION}-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

RUN set -ex; \
	\
# deal with slim variants not having man page directories (which causes "update-alternatives" to fail)
	if [ ! -d /usr/share/man/man1 ]; then \
		mkdir -p /usr/share/man/man1; \
	fi; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
		openjdk-${JAVA_VERSION}-jdk="$JAVA_DEBIAN_VERSION" \
#		openjdk-${JAVA_VERSION}-jdk \
	; \
	rm -rf /var/lib/apt/lists/*; \
	\
# update-alternatives so that future installs of other OpenJDK versions don't change /usr/bin/java
	update-alternatives --get-selections | awk -v home="$(readlink -f "$JAVA_HOME")" 'index($3, home) == 1 { $2 = "manual"; print | "update-alternatives --set-selections" }'; \
# ... and verify that it actually worked for one of the alternatives we care about
	update-alternatives --query java | grep -q 'Status: manual'

###################################
#### ---- Install Maven 3 ---- ####
###################################
ARG MAVEN_VERSION=${MAVEN_VERSION:-3.6.3}
ENV MAVEN_VERSION=${MAVEN_VERSION}
ENV MAVEN_HOME=/usr/apache-maven-${MAVEN_VERSION}
ENV PATH=${PATH}:${MAVEN_HOME}/bin
RUN curl -sL http://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  | gunzip \
  | tar x -C /usr/ \
  && ln -s ${MAVEN_HOME} /usr/maven

########################################
#### ---- PIP install packages ---- ####
########################################
COPY requirements.txt ./

## -- if pkg-resources error occurs, then do this! -- ##
# pip3 uninstall pkg-resources==0.0.0
RUN pip3 --no-cache-dir install --upgrade pip 
RUN pip3 --no-cache-dir install --ignore-installed -U -r requirements.txt

## -- added Local PIP installation bin to PATH
ENV PATH=${PATH}:${HOME}/.local/bin

## VERSIONS ##
ENV PATH=${PATH}:${JAVA_HOME}/bin

RUN ln -s ${JAVA_HOME_ACTUAL} ${JAVA_HOME} && \
    ls -al ${INSTALL_DIR} && \
    echo "PATH=${PATH}" && export JAVA_HOME=${JAVA_HOME} && export PATH=$PATH && \
    java -version && \
    mvn --version && \
    python -V && \
    python3 -V && \
    pip3 --version

###################################
#### ---- Install Gradle ---- #####
###################################
# Ref: https://gradle.org/releases/

ARG GRADLE_INSTALL_BASE=${GRADLE_INSTALL_BASE:-/opt/gradle}
ARG GRADLE_VERSION=${GRADLE_VERSION:-6.0.1}

ARG GRADLE_HOME=${GRADLE_INSTALL_BASE}/gradle-${GRADLE_VERSION}
ENV GRADLE_HOME=${GRADLE_HOME}
ARG GRADLE_PACKAGE=gradle-${GRADLE_VERSION}-bin.zip
ARG GRADLE_PACKAGE_URL=https://services.gradle.org/distributions/${GRADLE_PACKAGE}

RUN mkdir -p ${GRADLE_INSTALL_BASE} && \
    cd ${GRADLE_INSTALL_BASE} && \
    wget -q --no-check-certificate -c ${GRADLE_PACKAGE_URL} && \
    unzip -d ${GRADLE_INSTALL_BASE} ${GRADLE_PACKAGE} && \
    ls -al ${GRADLE_HOME} && \
    ln -s ${GRADLE_HOME}/bin/gradle /usr/bin/gradle && \
    ${GRADLE_HOME}/bin/gradle -v && \
    rm -f ${GRADLE_PACKAGE}

#########################################
#### ---- Node from NODESOURCES ---- ####
#########################################
# Ref: https://github.com/nodesource/distributions
ARG NODE_VERSION=${NODE_VERSION:-13}
ENV NODE_VERSION=${NODE_VERSION}
RUN apt-get update -y && \
    apt-get install -y sudo curl git xz-utils && \
    curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - && \
    apt-get install -y nodejs
    
RUN cd ${SCRIPT_DIR}; ${SCRIPT_DIR}/setup_npm_proxy.sh

###################################
#### ---- Update: all     ---- ####
###################################
RUN apt-get update -y

###################################
#### ---- user: developer ---- ####
###################################
ENV USER_ID=${USER_ID:-1000}
ENV GROUP_ID=${GROUP_ID:-1000}
ENV USER=${USER:-developer}
ENV HOME=/home/${USER}

## -- setup NodeJS user profile
RUN groupadd ${USER} && useradd ${USER} -m -d ${HOME} -s /bin/bash -g ${USER} && \
    ## -- Ubuntu -- \
    usermod -aG sudo ${USER} && \
    ## -- Centos -- \
    #usermod -aG wheel ${USER} && \
    echo "${USER} ALL=NOPASSWD:ALL" | tee -a /etc/sudoers && \
    echo "USER =======> ${USER}" && ls -al ${HOME}

##############################
#### ---- NPM PREFIX ---- ####
##############################
ENV NPM_CONFIG_PREFIX=${NPM_CONFIG_PREFIX:-${HOME}/.npm-global}
ENV PATH="${NPM_CONFIG_PREFIX}/bin:$PATH"
RUN mkdir -p ${NPM_CONFIG_PREFIX} ${HOME}/.config ${HOME}/.npm && \
    chown ${USER}:${USER} -R ${NPM_CONFIG_PREFIX} ${HOME}/.config ${HOME}/.npm && \
    export PATH=$PATH && ${SCRIPT_DIR}/install-npm-packages.sh

###########################################
#### ---- entrypoint script setup ---- ####
###########################################
RUN ln -s ${INSTALL_DIR}/scripts/docker-entrypoint.sh /docker-entrypoint.sh

#############################################
#### ---- USER as Owner for scripts ---- ####
#############################################
RUN chown ${USER}:${USER} -R ${INSTALL_DIR}/scripts /docker-entrypoint.sh

############################################
#### ---- Set up user environments ---- ####
############################################
ENV WORKSPACE=${HOME}/workspace
ENV DATA=${HOME}/data
USER ${USER}
WORKDIR ${HOME}

############################################
#### ---- Volumes: data, workspace ---- ####
############################################
RUN mkdir -p ${WORKSPACE} ${DATA}
COPY ./examples ${DATA}/examples
VOLUME ${DATA}
VOLUME ${WORKSPACE}

#########################
#### ---- Entry ---- ####
#########################
USER ${USER}
WORKDIR ${HOME}
#### Define default command.
#ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/bash"]

