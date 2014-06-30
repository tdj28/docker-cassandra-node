FROM ubuntu:12.04
MAINTAINER ti.do.jo@gmail.com

ENV DEBIAN_FRONTEND noninteractive
USER root

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y curl 

#RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u55-b13/jdk-7u55-linux-x64.tar.gz
#RUN curl -LO 'http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.rpm' -H 'Cookie: oraclelicense=accept-securebackup-cookie'
RUN curl -LO 'http://download.oracle.com/otn-pub/java/jdk/7u55-b13/jdk-7u55-linux-x64.tar.gz' -H 'Cookie: oraclelicense=accept-securebackup-cookie'

RUN tar zxvf *.tar.gz
RUN mkdir /usr/lib/jvm
RUN mv jdk1.7.0_55 /usr/lib/jvm
RUN update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk1.7.0_55/bin/javac 1
RUN update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk1.7.0_55/bin/java 1
RUN update-alternatives --install /usr/bin/javaws javaws /usr/lib/jvm/jdk1.7.0_55/bin/javaws 1


#RUN wget http://archive.cloudera.com/cdh4/one-click-install/lucid/amd64/cdh4-repository_1.0_all.deb
RUN curl -LO 'http://archive.cloudera.com/cdh4/one-click-install/lucid/amd64/cdh4-repository_1.0_all.deb'
RUN dpkg -i cdh4-repository_1.0_all.deb
RUN curl -s http://archive.cloudera.com/cdh4/ubuntu/lucid/amd64/cdh/archive.key | apt-key add -
RUN sed -i s/"deb "/"deb [arch=amd64] "/g /etc/apt/sources.list.d/cloudera-cdh4.list

RUN apt-get update
RUN apt-get -y upgrade

RUN export JAVA_HOME=/usr/lib/jvm/jdk1.7.0_55
RUN apt-get -y install hadoop-0.20-conf-pseudo
RUN echo "JAVA_HOME=/usr/lib/jvm/jdk1.7.0_55\n$(cat /usr/lib/hadoop/libexec/hadoop-config.sh)" > /usr/lib/hadoop/libexec/hadoop-config.sh
RUN echo "JAVA_HOME=/usr/lib/jvm/jdk1.7.0_55\n$(cat /usr/lib/hadoop-0.20-mapreduce/bin/hadoop-config.sh)" > /usr/lib/hadoop-0.20-mapreduce/bin/hadoop-config.sh
RUN cat /usr/lib/hadoop/libexec/hadoop-config.sh

#/etc/haddop/conf.pseudo.mrl/hdfs-site.xml--->data.dir=/var/lib/hadoop-hdfs/... --> EBS


#USER hdfs
## Format hdfs file system
#RUN hdfs namenode -format




USER root
#Install SSH
RUN apt-get install -y openssh-server 
RUN mkdir -p /root/.ssh
RUN mkdir /var/run/sshd
RUN chmod -rx /var/run/sshd
RUN chmod 700 /root/.ssh

#Some ssh fixes
RUN sed 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
#https://github.com/dotcloud/docker/issues/4846
RUN sed -i  '/pam_loginuid/s/^/#/' /etc/pam.d/sshd

## Cleanup
ADD ./adds/id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys*
RUN chown -Rf root:root /root/.ssh
RUN echo LANG=”en_US.UTF-8” > /etc/default/locale

#ADD adds/supervisord.conf /etc/supervisord.conf
ADD adds/start.sh /etc/start.sh

EXPOSE 50020 50030 50090 50070 50010 50075 8031 8032 8033 8040 8042 49707 22 8088 8030

#CMD ["/usr/local/bin/supervisord","-n"]
CMD ["/bin/bash", "/etc/start.sh", "-d"]
