# Java 8 (1.8.0_131) JRE server + Maven 3.5.0 + Python 3.5.2

[![](https://imagelayers.io/badge/openkbs/jre-mvn-py3:latest.svg)](https://imagelayers.io/?images=openkbs/jre-mvn-py3:latest 'Get your own badge on imagelayers.io')

##Components:
Components:
* Oracle Java "1.8.0_131" JRE Runtime Environment for Server
  Java(TM) SE Runtime Environment (build 1.8.0_131-b11)
* Apache Maven 3.5.0
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
docker run -it --rm openkbs/jre-mvn-py3 python3 -c 'print("Hello World")'
```

or,

```bash
docker run -i --rm openkbs/jre-mvn-py3 python3 < myPyScript.py 
```

or,

```bash
mkdir ./data
echo "print('Hello World')" > ./data/myPyScript.py
docker run -it --rm --name some-jre-mvn-py3 -v "$PWD"/data:/data openkbs/jre-mvn-py3 python3 myPyScript.py
```

or,

```bash
alias dpy3='docker run --rm openkbs/jre-mvn-py3 python3'
dpy3 -c 'print("Hello World")'
```

## Compile or Run java while no local installation needed
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
alias djavac='docker run -it --rm --name some-jre-mvn-py3 -v '$PWD'/data:/data openkbs/jre-mvn-py3 javac'
alias djava='docker run -it --rm --name some-jre-mvn-py3 -v '$PWD'/data:/data openkbs/jre-mvn-py3 java'

djavac HelloWorld.java
djava HelloWorld
```
And, the output:
```
Hello, World
```
Hence, the alias above, "djavac" and "djava" is your docker-based "javac" and "java" commands and 
it will work the same way as your local installed Java's "javac" and "java" commands. 
However, for larger complex projects, you might want to consider to use Docker-based IDE. 
For example, try this docker-scala-ide:
[Scala IDE in Docker](https://github.com/stevenalexander/docker-scala-ide)
See also,
[Java Development in Docker](https://blog.giantswarm.io/getting-started-with-java-development-on-docker/)
