#!/bin/bash

/etc/init.d/ssh start

chown -R hdfs.hdfs /var/lib/hadoop-hdfs

## Eventually make this conditional so doesn't rewrite entire data dir
su - hdfs -c "yes | hdfs namenode -format" 

/etc/init.d/hadoop-hdfs-namenode start
/etc/init.d/hadoop-hdfs-secondarynamenode start
/etc/init.d/hadoop-hdfs-datanode start


#/te the temp directory
su - hdfs -c "hadoop fs -mkdir /tmp"
su - hdfs -c "hadoop fs -chmod -R 1777 /tmp"

# create the map reduce system directories
su - hdfs -c "hadoop fs -mkdir /var"
su - hdfs -c "hadoop fs -mkdir /var/lib"
su - hdfs -c "hadoop fs -mkdir /var/lib/hadoop-hdfs"
su - hdfs -c "hadoop fs -mkdir /var/lib/hadoop-hdfs/cache"
su - hdfs -c "hadoop fs -mkdir /var/lib/hadoop-hdfs/cache/mapred"
su - hdfs -c "hadoop fs -mkdir /var/lib/hadoop-hdfs/cache/mapred/mapred"
su - hdfs -c "hadoop fs -mkdir /var/lib/hadoop-hdfs/cache/mapred/mapred/staging"
su - hdfs -c "hadoop fs -chmod 1777 /var/lib/hadoop-hdfs/cache/mapred/mapred/staging"
su - hdfs -c "hadoop fs -chown -R mapred /var/lib/hadoop-hdfs/cache/mapred"

/etc/init.d/hadoop-0.20-mapreduce-jobtracker start
/etc/init.d/hadoop-0.20-mapreduce-tasktracker start



if [[ $1 == "-d" ]]; then
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi
