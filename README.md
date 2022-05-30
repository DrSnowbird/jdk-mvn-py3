# OpenJDK Java 11 + Maven 3.6 + Python 3.6  + pip 21 + node 16 + npm 7 + Yarn + Gradle 6

[![](https://images.microbadger.com/badges/image/openkbs/jdk-mvn-py3.svg)](https://microbadger.com/images/openkbs/jdk-mvn-py3 "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/openkbs/jdk-mvn-py3.svg)](https://microbadger.com/images/openkbs/jdk-mvn-py3 "Get your own version badge on microbadger.com")

# ** Currently Docker Hub not allowing for free hosting for Docker images: Please run ./build.sh first by yourself locally **

# NOTICE: Change to use `Non-Root` implementation
This new release is designed to support the deployment for Non-Root child images implementations and deployments to platform such as OpenShift or RedHat host operating system which requiring special policy to deploy. And, for better security practice, we decided to migrate (eventaully) our Docker containers to use Non-Root implementation. 
Here are some of the things you can do if your images requiring "Root" acccess - you `really` want to do it:
1. For Docker build: Use "sudo" or "sudo -H" prefix to your Dockerfile's command which requiring "sudo" access to install packages.
2. For Docker container (access via shell): Use "sudo" command when you need to access root privilges to install packages or change configurations.
3. Or, you can use older version of this kind of base images which use "root" in Dockerfile.
4. Yet, you can also modify the Dockerfile at the very bottom to remove/comment out the "USER ${USER}" line so that your child images can have root as USER.
5. Finally, you can also, add a new line at the very top of your child Docker image's Dockerfile to include "USER root" so that your Docker images built will be using "root".

We like to promote the use of "Non-Root" images as better Docker security practice. And, whenever possible, you also want to further confine the use of "root" privilges in your Docker implementation so that it can prevent the "rooting hacking into your Host system". To lock down your docker images and/or this base image, you will add the following line at the very end to remove sudo: `(Notice that this might break some of your run-time code if you use sudo during run-time)`
```
sudo agt-get remove -y sudo
```
After that, combining with other Docker security practice (see below references), you just re-build your local images and re-deploy it as non-development quality of docker container. However, there are many other practices to secure your Docker containes. See below:

* [Docker security | Docker Documentation](https://docs.docker.com/engine/security/security/)
* [5 tips for securing your Docker containers - TechRepublic](https://www.techrepublic.com/article/5-tips-for-securing-your-docker-containers/)
* [Docker Security - 6 Ways to Secure Your Docker Containers](https://www.sumologic.com/blog/security/securing-docker-containers/)
* [Five Docker Security Best Practices - The New Stack](https://thenewstack.io/5-docker-security-best-practices/)

# Components
* Ubuntu 18.04 LTS now and we will use Ubuntu 20.04 soon as LTS Docker base image.
* openjdk version "11.0.11" 2021-04-20
	OpenJDK Runtime Environment (build 11.0.11+9-Ubuntu-0ubuntu2.18.04)
	OpenJDK 64-Bit Server VM (build 11.0.11+9-Ubuntu-0ubuntu2.18.04, mixed mode, sharing)
* Apache Maven 3.6
* Python 3.6 + pip 21 + Python 3 virtual environments (venv, virtualenv, virtualenvwrapper, mkvirtualenv, ..., etc.)
* Node v16 + npm 7 (from NodeSource official Node Distribution)
* Gradle 6.7
* Yarn 1.22
* Other tools: git wget unzip vim python python-setuptools python-dev python-numpy, ..., etc.
* [See Releases Information](https://github.com/DrSnowbird/jdk-mvn-py3/blob/master/README.md#Releases-information)

## Note about "Yarn"
Yarn has now been added since few requests for supporting Yarn. However, at this point, the impact to all child Containers is not assured yet. Please report any issue for child Containers or derivative Containers based upon this base Container image.

# Quick commands
* build.sh - build local image.
* logs.sh - see logs of container.
* run.sh - run the container.
* shell.sh - shell into the container.
* save.sh - save a running Container instance into a tgz file for later to restore.
* restore.sh - restore the previously archived tgz Container instance ready for running again.
* stop.sh - stop the container.
* tryJava.sh : test Java
* tryNodeJS.sh : test NodeJS
* tryPython.sh : test Python
* tryWebSocketServer.sh : test WebSockert NodeJS Server

# How to use and quick start running?
1. git clone https://github.com/DrSnowbird/jdk-mvn-py3.git
2. cd jdk-mvn-py3
3. ./run.sh

# Default Run (test) - Just entering Container
```
./build.sh or 'make build'
./run.sh
```

# Test Java, NodeJS, and Python3 Runs
```
./tryJava.sh
./tryNodeJS.sh
./tryPython.sh
./tryWebSockerServer.sh
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
... (then your customization Dockerfile code here)
```

# Manually setup to Run the image

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

# Compile or Run java -- while no local installation needed
Remember, the default working directory, /data, inside the docker container -- treat is as "/".
So, if you create subdirectory, "./data/workspace", in the host machine and 
the docker container will have it as "/data/workspace".

```
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

# Run JavaScript -- while no local installation needed
Run the NodeJS mini-server script:
```
./tryNodeJS.sh
```
Then, open web browser to go to http://0.0.0.0:3000/ to NodeJS mini-web server test.

# Python Virtual Environments
There are various ways to run Python virtual envrionments, for example,

### Setup virtualenvwrapper in $HOME/.bashrc profile
Add the following code to the end of ~/.bashrc
```
#########################################################################
#### ---- Customization for multiple virtual python environment ---- ####
#########################################################################
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source /usr/local/bin/virtualenvwrapper.sh
export WORKON_HOME=~/Envs
if [ ! -d $WORKON_HOME ]; then
    mkdir -p $WORKON_HOME
fi
```

### To create & activate your default venv environment, say, "my-venv":
```
mkvirtualenv my-venv
workon my-venv
```

# To run specialty Java/Scala IDE alternatives
However, for larger complex projects, you might want to consider to use Docker-based IDE. 
For example, try the following Docker-based IDEs:
* [openkbs/docker-atom-editor](https://hub.docker.com/r/openkbs/docker-atom-editor/)
* [openkbs/eclipse-photon-docker](https://hub.docker.com/r/openkbs/eclipse-photon-docker/)
* [openkbs/eclipse-photon-vnc-docker](https://hub.docker.com/r/openkbs/eclipse-photon-vnc-docker/)
* [openkbs/eclipse-oxygen-docker](https://hub.docker.com/r/openkbs/eclipse-oxygen-docker/)
* [openkbs/intellj-docker](https://hub.docker.com/r/openkbs/intellij-docker/)
* [openkbs/intellj-vnc-docker](https://hub.docker.com/r/openkbs/intellij-vnc-docker/)
* [openkbs/knime-vnc-docker](https://hub.docker.com/r/openkbs/knime-vnc-docker/)
* [openkbs/netbeans9-docker](https://hub.docker.com/r/openkbs/netbeans9-docker/)
* [openkbs/netbeans](https://hub.docker.com/r/openkbs/netbeans/)
* [openkbs/papyrus-sysml-docker](https://hub.docker.com/r/openkbs/papyrus-sysml-docker/)
* [openkbs/pycharm-docker](https://hub.docker.com/r/openkbs/pycharm-docker/)
* [openkbs/scala-ide-docker](https://hub.docker.com/r/openkbs/scala-ide-docker/)
* [openkbs/sublime-docker](https://hub.docker.com/r/openkbs/sublime-docker/)
* [openkbs/webstorm-docker](https://hub.docker.com/r/openkbs/webstorm-docker/)
* [openkbs/webstorm-vnc-docker](https://hub.docker.com/r/openkbs/webstorm-vnc-docker/)

# See also
* [Java Development in Docker](https://blog.giantswarm.io/getting-started-with-java-development-on-docker/)
* [Alpine small image JDKs](https://github.com/frol/docker-alpine-oraclejdk8)
* [NPM Prefix for not using SUDO NPM](https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally)

# Proxy & Certificate Setup
* [Setup System and Browsers Root Certificate](https://thomas-leister.de/en/how-to-import-ca-root-certificate/)

# Corporate Proxy Root and Intemediate Certificates setup for System and Web Browsers (FireFox, Chrome, etc)
1. Save your corporate's Certificates in the currnet GIT directory, `./certificates`
2. During Docker run command, 
```
   -v `pwd`/certificates:/certificates ... (the rest parameters)
```
If you want to map to different directory for certificates, e.g., /home/developer/certificates, then
```
   -v `pwd`/certificates:/home/developer/certificates -e SOURCE_CERTIFICATES_DIR=/home/developer/certificates ... (the rest parameters)
```
3. And, inside the Docker startup script to invoke the `~/scripts/setup_system_certificates.sh`. Note that the script assumes the certficates are in `/certificates` directory.
4. The script `~/scripts/setup_system_certificates.sh` will automatic copy to target directory and setup certificates for both System commands (wget, curl, etc) to use and Web Browsers'.

# Releases information
```
developer@aurora:~$ /usr/scripts/printVersions.sh 
JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
java: /usr/bin/java /usr/share/java /usr/lib/jvm/java-11-openjdk-amd64/bin/java /usr/share/man/man1/java.1.gz

/usr/lib/jvm/java-11-openjdk-amd64/bin/java
openjdk version "11.0.15" 2022-04-19
OpenJDK Runtime Environment (build 11.0.15+10-Ubuntu-0ubuntu0.18.04.1)
OpenJDK 64-Bit Server VM (build 11.0.15+10-Ubuntu-0ubuntu0.18.04.1, mixed mode, sharing)
/usr/bin/mvn
Apache Maven 3.8.5 (3599d3414f046de2324203b78ddcf9b5e4388aa0)
Maven home: /usr/apache-maven-3.8.5
Java version: 11.0.15, vendor: Private Build, runtime: /usr/lib/jvm/java-11-openjdk-amd64
Default locale: en, platform encoding: UTF-8
OS name: "linux", version: "5.11.0-34-generic", arch: "amd64", family: "unix"
/usr/bin/python
Python 2.7.17
/usr/bin/python3
Python 3.6.9
/usr/local/bin/pip
pip 21.3.1 from /usr/local/lib/python3.6/dist-packages/pip (python 3.6)
/usr/local/bin/pip3
pip 21.3.1 from /usr/local/lib/python3.6/dist-packages/pip (python 3.6)
/usr/bin/gradle

Welcome to Gradle 7.4.2!

Here are the highlights of this release:
 - Aggregated test and JaCoCo reports
 - Marking additional test source directories as tests in IntelliJ
 - Support for Adoptium JDKs in Java toolchains

For more details see https://docs.gradle.org/7.4.2/release-notes.html


------------------------------------------------------------
Gradle 7.4.2
------------------------------------------------------------

Build time:   2022-03-31 15:25:29 UTC
Revision:     540473b8118064efcc264694cbcaa4b677f61041

Kotlin:       1.5.31
Groovy:       3.0.9
Ant:          Apache Ant(TM) version 1.10.11 compiled on July 10 2021
JVM:          11.0.15 (Private Build 11.0.15+10-Ubuntu-0ubuntu0.18.04.1)
OS:           Linux 5.11.0-34-generic amd64

/usr/bin/npm
8.11.0
/usr/bin/node
v17.9.0
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=18.04
DISTRIB_CODENAME=bionic
DISTRIB_DESCRIPTION="Ubuntu 18.04.6 LTS"
NAME="Ubuntu"
VERSION="18.04.6 LTS (Bionic Beaver)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 18.04.6 LTS"
VERSION_ID="18.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=bionic
UBUNTU_CODENAME=bionic
```

## Python3 PIP Modules
```
developer@aurora:~$ pip freeze
argon2-cffi==21.3.0
argon2-cffi-bindings==21.2.0
asn1crypto==0.24.0
async-generator==1.10
attrs==21.4.0
backcall==0.2.0
beautifulsoup4==4.6.0
bleach==4.1.0
certifi==2022.5.18.1
cffi==1.15.0
chardet==3.0.4
charset-normalizer==2.0.12
cloudpickle==2.1.0
cryptography==2.1.4
cycler==0.11.0
dataclasses==0.8
decorator==4.4.2
defusedxml==0.7.1
distlib==0.3.4
entrypoints==0.4
filelock==3.4.1
funcy==1.17
future==0.18.2
greenlet==1.1.2
html5lib==0.999999999
httpie==2.6.0
hyperopt==0.2.7
idna==3.3
importlib-metadata==4.8.3
importlib-resources==5.4.0
ipaddress==1.0.23
ipykernel==5.5.6
ipython==7.16.3
ipython-genutils==0.2.0
ipywidgets==7.7.0
j2cli==0.3.10
jedi==0.17.2
Jinja2==3.0.3
joblib==1.1.0
json-lines==0.5.0
jsonschema==3.2.0
jupyter==1.0.0
jupyter-client==7.1.2
jupyter-console==6.4.3
jupyter-core==4.9.2
jupyterlab-pygments==0.1.2
jupyterlab-widgets==1.1.0
keyring==10.6.0
keyrings.alt==3.0
kiwisolver==1.3.1
lxml==4.2.1
MarkupSafe==2.0.1
matplotlib==3.3.4
mistune==0.8.4
nbclient==0.5.9
nbconvert==6.0.7
nbformat==5.1.3
nest-asyncio==1.5.5
networkx==2.5.1
notebook==6.4.10
numexpr==2.8.1
numpy==1.19.5
olefile==0.45.1
packaging==21.3
panda==0.3.1
pandas==0.24.2
pandasql==0.7.3
pandocfilters==1.5.0
parso==0.7.1
pbr==5.9.0
pexpect==4.8.0
pickleshare==0.7.5
Pillow==8.4.0
pkgconfig==1.5.5
platformdirs==2.4.0
prometheus-client==0.14.1
prompt-toolkit==3.0.29
ptyprocess==0.7.0
py4j==0.10.9.5
pycparser==2.21
pycrypto==2.6.1
pydot==1.4.2
Pygments==2.12.0
PyGObject==3.26.1
pyLDAvis==3.2.2
pyparsing==3.0.9
pyrsistent==0.18.0
PySocks==1.7.1
python-apt==1.6.5+ubuntu0.7
python-dateutil==2.5.2
python-git==2018.2.1
pytz==2022.1
pyxdg==0.25
PyYAML==3.11
pyzmq==23.0.0
qtconsole==5.2.2
QtPy==2.0.1
requests==2.27.1
requests-toolbelt==0.9.1
scikit-learn==0.24.2
scipy==1.5.4
seaborn==0.11.2
SecretStorage==2.3.1
Send2Trash==1.8.0
six==1.16.0
SQLAlchemy==1.4.36
stevedore==3.5.0
tables==3.4.2
terminado==0.12.1
testpath==0.6.0
threadpoolctl==3.1.0
tornado==6.1
tqdm==4.64.0
traitlets==4.3.3
typing_extensions==4.1.1
unattended-upgrades==0.1
urllib3==1.26.9
virtualenv==20.14.1
virtualenv-clone==0.5.7
virtualenvwrapper==4.8.4
wcwidth==0.2.5
webencodings==0.5.1
widgetsnbextension==3.6.0
yml2json==1.1.3
zipp==3.6.0
```
