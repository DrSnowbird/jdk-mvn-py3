# Java 8 (1.8.0_92) JRE server + Maven 3.3.9 + PyDev 3.5.1

[![](https://imagelayers.io/badge/openkbs/jre-mvn-py:latest.svg)](https://imagelayers.io/?images=openkbs/jre-mvn-py:latest 'Get your own badge on imagelayers.io')

Components:

* Oracle Java "1.8.0_92" JRE Runtime Environment for Server
  Java(TM) SE Runtime Environment (build 1.8.0_92-b14)
  Java HotSpot(TM) 64-Bit Server VM (build 25.92-b14, mixed mode)
* Apache Maven 3.3.9
* Python 3.5.1+
* Other tools: git wget unzip vim python python-setuptools python-dev python-numpy 

## Pull the image from Docker Repository


```bash
docker pull openkbs/jre-mvn-py3
```

## Base the image to build add-on components

```Dockerfile
FROM openkbs/jre-mvn-py3
```

## Run the image

Then, you're ready to run:
- make sure you create your work directory, e.g., ./data

```bash
mkdir ./data
docker run -d --name my-jre-mvn-py3 -v $PWD/data:/data -i -t openkbs/jre-mvn-py3
```

## Build and Run your own image
Say, you will build the image "my/jre-mvn-py3".

```bash
docker build -t my/jre-mvn-py3 .
```

To run your own image, say, with some-jre-mvn-py3:

```bash
mkdir ./data
docker run -d --name some-jre-mvn-py3 -v $PWD/data:/data -i -t my/jre-mvn-py3
```

## Shell into the Docker instance

```bash
docker exec -it some-jre-mvn-py3 /bin/bash
```

## Run Python code

To run Python code 

```bash
docker run --rm openkbs/jre-mvn-py3 python3 -c 'print("Hello World")'
```

or,

```bash
docker run --rm openkbs/jre-mvn-py3 python3 < myPyScript.py 
```

or,

```bash
alias dpy3='docker run --rm openkbs/jre-mvn-py3 python3'
dpy3 -c 'print("Hello World")'
dpy3 < myPyScript.py
```

