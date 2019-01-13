FROM ubuntu:xenial
# use the latest LTS Ubuntu

MAINTAINER openkbs.org@gmail.com

ENV DEBIAN_FRONTEND noninteractive

# ref: https://github.com/dockerfile/java/tree/master/oracle-java8

########################################
##### update ubuntu and Install Python 3
########################################
RUN apt-get update && \
    apt-get install -y apt-utils automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev && \
    apt-get install -y curl net-tools build-essential software-properties-common libsqlite3-dev sqlite3 bzip2 libbz2-dev git wget unzip vim python3-pip python3-setuptools python3-dev python3-numpy python3-scipy python3-pandas python3-matplotlib && \
    apt-get install -y git xz-utils && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV INSTALL_DIR=${INSTALL_DIR:-/usr}

###################################
#### Install Java 8
###################################
#### ---------------------------------------------------------------
#### ---- Change below when upgrading version ----
#### ---------------------------------------------------------------
## http://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/jdk-8u191-linux-x64.tar.gz
ARG JAVA_MAJOR_VERSION=${JAVA_MAJOR_VERSION:-8}
ARG JAVA_UPDATE_VERSION=${JAVA_UPDATE_VERSION:-191}
ARG JAVA_BUILD_NUMBER=${JAVA_BUILD_NUMBER:-12}
ARG JAVA_DOWNLOAD_TOKEN=${JAVA_DOWNLOAD_TOKEN:-2787e4a523244c269598db4e85c51e0c}

#### ---------------------------------------------------------------
#### ---- Don't change below unless you know what you are doing ----
#### ---------------------------------------------------------------
ARG UPDATE_VERSION=${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}
ARG BUILD_VERSION=b${JAVA_BUILD_NUMBER}

ENV JAVA_HOME_ACTUAL=${INSTALL_DIR}/jdk1.${JAVA_MAJOR_VERSION}.0_${JAVA_UPDATE_VERSION}
ENV JAVA_HOME=${INSTALL_DIR}/java

ENV PATH=$PATH:${JAVA_HOME}/bin

WORKDIR ${INSTALL_DIR}

RUN curl -sL --retry 3 --insecure \
  --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
  "http://download.oracle.com/otn-pub/java/jdk/${UPDATE_VERSION}-${BUILD_VERSION}/${JAVA_DOWNLOAD_TOKEN}/jdk-${UPDATE_VERSION}-linux-x64.tar.gz" \
  | gunzip \
  | tar x -C ${INSTALL_DIR}
RUN ls -al ${INSTALL_DIR} && \
  ln -s ${JAVA_HOME_ACTUAL} ${JAVA_HOME} && \
  rm -rf ${JAVA_HOME}/man

############################
#### --- JAVA_HOME --- #####
############################
ENV JAVA_HOME=$INSTALL_DIR/java

###################################
#### Install Maven 3
###################################
ARG MAVEN_VERSION=${MAVEN_VERSION:-3.6.0}
ENV MAVEN_VERSION=${MAVEN_VERSION}
ENV MAVEN_HOME=/usr/apache-maven-${MAVEN_VERSION}
ENV PATH=${PATH}:${MAVEN_HOME}/bin
RUN curl -sL http://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  | gunzip \
  | tar x -C /usr/ \
  && ln -s ${MAVEN_HOME} /usr/maven

###################################
#### ---- Pip install packages ----
###################################
COPY requirements.txt ./

## ---------------------------------------------------
## Don't upgrade pip to 10.0.x version -- it's broken! 
## Staying with version 8 to avoid the problem
## ---------------------------------------------------

RUN pip3 install --upgrade pip 
RUN pip3 install -r ./requirements.txt 

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
ARG GRADLE_INSTALL_BASE=${GRADLE_INSTALL_BASE:-/opt/gradle}
ARG GRADLE_VERSION=${GRADLE_VERSION:-5.1.1}

ARG GRADLE_HOME=${GRADLE_INSTALL_BASE}/gradle-${GRADLE_VERSION}
ENV GRADLE_HOME=${GRADLE_HOME}
ARG GRADLE_PACKAGE=gradle-${GRADLE_VERSION}-bin.zip
ARG GRADLE_PACKAGE_URL=https://services.gradle.org/distributions/${GRADLE_PACKAGE}
# https://services.gradle.org/distributions/gradle-5.1.1-bin.zip
RUN \
    mkdir -p ${GRADLE_INSTALL_BASE} && \
    cd ${GRADLE_INSTALL_BASE} && \
    wget -c ${GRADLE_PACKAGE_URL} && \
    unzip -d ${GRADLE_INSTALL_BASE} ${GRADLE_PACKAGE} && \
    ls -al ${GRADLE_HOME} && \
    ln -s ${GRADLE_HOME}/bin/gradle /usr/bin/gradle && \
    ${GRADLE_HOME}/bin/gradle -v && \
    rm -f ${GRADLE_PACKAGE}

###################################
#### define working directory. ####
###################################
RUN mkdir -p /data 

COPY ./printVersions.sh ./

VOLUME "/data"

WORKDIR /data

#### Define default command.
CMD ["/bin/bash"]

