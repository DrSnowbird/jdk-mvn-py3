# ref: https://github.com/dockerfile/java/tree/master/oracle-java8

# use the latest LTS Ubuntu
FROM ubuntu:xenial

MAINTAINER openkbs

ENV DEBIAN_FRONTEND noninteractive

##### update ubuntu and Install Python 3
RUN apt-get update \
  && apt-get install -y curl net-tools build-essential git wget unzip vim python3-pip python3-setuptools python3-dev python3-numpy \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

#### Install Java 8
# define JAVA_HOME variable

#http://download.oracle.com/otn-pub/java/jdk/8u102-b14/jdk-8u102-linux-x64.rpm
#http://download.oracle.com/otn-pub/java/jdk/8u102-b14/jre-8u102-linux-x64.rpm
#http://download.oracle.com/otn-pub/java/jdk/8u102-b14/server-jre-8u102-linux-x64.rpm

## -- Change these three lines for Java version upgrade --
ENV JAVA_VERSION 8u102
ENV BUILD_VERSION b14
ENV JAVA_HOME /usr/jdk1.8.0_102
ENV JAVA_OS linux-x64
ENV JAVA_PACKAGE_FORMAT tar.gz

## -- Choose your Java Type: jdk, jre, server-jre
#ENV JAVA_PACKAGE_TYPE jdk
#ENV JAVA_PACKAGE_TYPE jre
ENV JAVA_PACKAGE_TYPE server-jre

## -- No need to change these lines below unless Java/Oracle change URL --
ENV PATH $PATH:$JAVA_HOME/bin

## -- Java Download site and path --
#ENV JAVA_PACKAGE_PATH $JAVA_VERSION-$BUILD_VERSION/$JAVA_PACKAGE_TYPE-$JAVA_VERSION-$JAVA_OS.$JAVA_PACKAGE_FORMAT
#ENV JAVA_DOWNLOAD_URL http://download.oracle.com/otn-pub/java/jdk/$JAVA_PACKAGE_PATH

## -- For RPM package, you need to change to use rpm or yum command correspondingly --
ENV INSTALL_DIR /usr/
RUN curl -sL --retry 3 --insecure \
  --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
  #"http://download.oracle.com/otn-pub/java/jdk/8u102-b14/server-jre-8u102-linux-x64.tar.gz" \
  "http://download.oracle.com/otn-pub/java/jdk/$JAVA_VERSION-$BUILD_VERSION/$JAVA_PACKAGE_TYPE-$JAVA_VERSION-$JAVA_OS.$JAVA_PACKAGE_FORMAT" \
  #"$JAVA_DOWNLOAD_URL" \
  | gunzip \
  | tar x -C $INSTALL_DIR \
  && ln -s $JAVA_HOME /usr/java \
  && rm -rf $JAVA_HOME/man

#### Install Maven 3
ENV MAVEN_VERSION 3.3.9
ENV MAVEN_HOME /usr/apache-maven-$MAVEN_VERSION
ENV PATH $PATH:$MAVEN_HOME/bin
RUN curl -sL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
  | gunzip \
  | tar x -C /usr/ \
  && ln -s $MAVEN_HOME /usr/maven

#### Clean up 
RUN apt-get clean

#### define working directory.
RUN mkdir -p /data
COPY . /data

VOLUME "/data"

WORKDIR /data

#### Define default command.
#ENTRYPOINT ["/bin/bash"]

