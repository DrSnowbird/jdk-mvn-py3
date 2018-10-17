# Java 8 (1.8.0_191) JDK + Maven 3.5 + Python 3.5 + PIP3 8.1.1 + Gradle 4.9

[![](https://images.microbadger.com/badges/image/openkbs/jdk-mvn-py3.svg)](https://microbadger.com/images/openkbs/jdk-mvn-py3 "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/openkbs/jdk-mvn-py3.svg)](https://microbadger.com/images/openkbs/jdk-mvn-py3 "Get your own version badge on microbadger.com")

# License Agreement
By using this image, you agree the [Oracle Java JDK License](http://www.oracle.com/technetwork/java/javase/terms/license/index.html).
This image contains [Oracle JDK 8](http://www.oracle.com/technetwork/java/javase/downloads/index.html). You must accept the [Oracle Binary Code License Agreement for Java SE](http://www.oracle.com/technetwork/java/javase/terms/license/index.html) to use this image.

# Components:
* java version "1.8.0_191"
  Java(TM) SE Runtime Environment (build 1.8.0_191-b12)
  Java HotSpot(TM) 64-Bit Server VM (build 25.191-b12, mixed mode)
* Apache Maven 3.5.3
* Python 3.5.2
* Gradle 4.9
* Other tools: git wget unzip vim python python-setuptools python-dev python-numpy 

# Default Run (test) - Just entering Container
```
./run.sh
```

# Test Java and Python3 Runs
```
./tryJava.sh
./tryPython.sh
```
# Default Build (locally)
```
./build.sh
```
# Pull the image from Docker Repository

```bash
docker pull openkbs/jdk-mvn-py3
```

# Base the image to build add-on components

```Dockerfile
FROM openkbs/jdk-mvn-py3
```

# Run the image

Then, you're ready to run:
- make sure you create your work directory, e.g., ./data

```bash
mkdir ./data
docker run -d --name my-jdk-mvn-py3 -v $PWD/data:/data -i -t openkbs/jdk-mvn-py3
```

# Build and Run your own image
Say, you will build the image "my/jdk-mvn-py3".

```bash
docker build -t my/jdk-mvn-py3 .
```

To run your own image, say, with some-jdk-mvn-py3:

```bash
mkdir ./data
docker run -d --name some-jdk-mvn-py3 -v $PWD/data:/data -i -t my/jdk-mvn-py3
```

# Shell into the Docker instance

```bash
docker exec -it some-jdk-mvn-py3 /bin/bash
```

# Run Python code

To run Python code 

```bash
docker run -it --rm openkbs/jdk-mvn-py3 python3 -c 'print("Hello World")'
```

or,

```bash
docker run -i --rm openkbs/jdk-mvn-py3 python3 < myPyScript.py 
```

or,

```bash
mkdir ./data
echo "print('Hello World')" > ./data/myPyScript.py
docker run -it --rm --name some-jdk-mvn-py3 -v "$PWD"/data:/data openkbs/jdk-mvn-py3 python3 myPyScript.py
```

or,

```bash
alias dpy3='docker run --rm openkbs/jdk-mvn-py3 python3'
dpy3 -c 'print("Hello World")'
```

# Compile or Run java while no local installation needed
Remember, the default working directory, /data, inside the docker container -- treat is as "/".
So, if you create subdirectory, "./data/workspace", in the host machine and 
the docker container will have it as "/data/workspace".

```java
#!/bin/bash -x
mkdir ./data
cat >./data/HelloWorld.java <<-EOF
public class HelloWorld {
   public static void main(String[] args) {
      System.out.println("Hello, World");
   }
}
EOF
cat ./data/HelloWorld.java
alias djavac='docker run -it --rm --name some-jdk-mvn-py3 -v '$PWD'/data:/data openkbs/jdk-mvn-py3 javac'
alias djava='docker run -it --rm --name some-jdk-mvn-py3 -v '$PWD'/data:/data openkbs/jdk-mvn-py3 java'

djavac HelloWorld.java
djava HelloWorld
```
And, the output:
```
Hello, World
```
Hence, the alias above, "djavac" and "djava" is your docker-based "javac" and "java" commands and 
it will work the same way as your local installed Java's "javac" and "java" commands. 

# To run specialty Java/Scala IDE alternatives
However, for larger complex projects, you might want to consider to use Docker-based IDE. 
For example, try the following Docker-based IDEs:
* [openkbs/eclipse-oxygen-docker](https://hub.docker.com/r/openkbs/eclipse-oxygen-docker/)
* [openkbs/netbeans](https://hub.docker.com/r/openkbs/netbeans/)
* [openkbs/scala-ide-docker](https://hub.docker.com/r/openkbs/scala-ide-docker/)
* [openkbs/pycharm-docker](https://hub.docker.com/r/openkbs/pycharm-docker/)
* [openkbs/webstorm-docker](https://hub.docker.com/r/openkbs/webstorm-docker/)
* [openkbs/intellj-docker](https://hub.docker.com/r/openkbs/intellij-docker/)

# See also
* [Java Development in Docker](https://blog.giantswarm.io/getting-started-with-java-development-on-docker/)
* [Alpine small image JDKs](https://github.com/frol/docker-alpine-oraclejdk8)

# Releases information
```
root@da05462f60da:/# ./printVersions.sh 
JAVA_HOME=/usr/jdk1.8.0_191
java version "1.8.0_191"
Java(TM) SE Runtime Environment (build 1.8.0_191-b12)
Java HotSpot(TM) 64-Bit Server VM (build 25.191-b12, mixed mode)
Apache Maven 3.5.4 (1edded0938998edf8bf061f1ceb3cfdeccf443fe; 2018-06-17T18:33:14Z)
Maven home: /usr/apache-maven-3.5.4
Java version: 1.8.0_191, vendor: Oracle Corporation, runtime: /usr/jdk1.8.0_191/jre
Default locale: en_US, platform encoding: ANSI_X3.4-1968
OS name: "linux", version: "4.15.0-36-generic", arch: "amd64", family: "unix"
Python 3.5.2
Python 3.5.2
pip 18.1 from /usr/local/lib/python3.5/dist-packages/pip (python 3.5)
pip 18.1 from /usr/local/lib/python3.5/dist-packages/pip (python 3.5)

------------------------------------------------------------
Gradle 4.9
------------------------------------------------------------

Build time:   2018-07-16 08:14:03 UTC
Revision:     efcf8c1cf533b03c70f394f270f46a174c738efc

Kotlin DSL:   0.18.4
Kotlin:       1.2.41
Groovy:       2.4.12
Ant:          Apache Ant(TM) version 1.9.11 compiled on March 23 2018
JVM:          1.8.0_191 (Oracle Corporation 25.191-b12)
OS:           Linux 4.15.0-36-generic amd64

DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=16.04
DISTRIB_CODENAME=xenial
DISTRIB_DESCRIPTION="Ubuntu 16.04.3 LTS"
NAME="Ubuntu"
VERSION="16.04.3 LTS (Xenial Xerus)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 16.04.3 LTS"
VERSION_ID="16.04"
HOME_URL="http://www.ubuntu.com/"
SUPPORT_URL="http://help.ubuntu.com/"
BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
VERSION_CODENAME=xenial
UBUNTU_CODENAME=xenial
```

