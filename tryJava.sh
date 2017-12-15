#!/bin/bash 
mkdir -p ./data
cat >./data/HelloWorld.java <<-EOF
public class HelloWorld {
   public static void main(String[] args) {
      System.out.println("Hello, World");
   }
}
EOF
cat ./data/HelloWorld.java
djavac='docker run -it --rm --name some-jdk-mvn-py3 -v '$PWD'/data:/data openkbs/jdk-mvn-py3 javac'
djava='docker run -it --rm --name some-jdk-mvn-py3 -v '$PWD'/data:/data openkbs/jdk-mvn-py3 java'

#docker run -it --rm --name some-jdk-mvn-py3 -v /home/user1/github/Java8-Maven-Python/jdk-mvn-py3/data:/data openkbs/jdk-mvn-py3 javac HelloWorld.java
$djavac HelloWorld.java

#docker run -it --rm --name some-jdk-mvn-py3 -v /home/user1/github/Java8-Maven-Python/jdk-mvn-py3/data:/data openkbs/jdk-mvn-py3 java HelloWorld
$djava HelloWorld


