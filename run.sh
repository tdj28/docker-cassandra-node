#!/bin/bash

CONTAINER_ID=$(docker run -p 1222:22 -p 50030:50030 -p 50070:50070 -v $PWD/hadoop-hdfs:/var/lib/hadoop-hdfs -d hadoop)
docker inspect $CONTAINER_ID | grep IPAddress | awk '{ print $2 }' | tr -d ',"' | tee my.ip
