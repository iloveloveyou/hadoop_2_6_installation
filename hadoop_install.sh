#!/bin/bash
#Java Installation Source: http://www.webupd8.org/2012/09/install-oracle-java-8-in-ubuntu-via-ppa.html

#Add java 8 repository
sudo add-apt-repository ppa:webupd8team/java

#Update repository
sudo apt-get update

#Setup Automated Installation
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections

#Install Java 8
sudo apt-get install oracle-java8-installer -y

#Install SSH
sudo apt-get install openssh-server -y	

#add hadoop group
sudo addgroup hadoop

#add hduser to hadoop group
sudo adduser --ingroup hadoop hduser

## Create Hadoop temp directories for Namenode and Datanode
sudo mkdir -p /usr/local/hadoop_tmp/hdfs/namenode
sudo mkdir -p /usr/local/hadoop_tmp/hdfs/datanode

#Assign ownership to hadoop group
sudo chrown hduser:hadoop -R /usr/local/hadoop
sudo chown hduser:hadoop -R /usr/local/hadoop_tmp/

#Disable IPV6
echo net.ipv6.conf.all.disable_ipv6 = 1 >> /etc/sysctl.conf
echo net.ipv6.conf.default.disable_ipv6 = 1 >> /etc/sysctl.conf
echo net.ipv6.conf.lo.disable_ipv6 = 1 >> /etc/sysctl.conf

#Login in with hduser
sudo su hduser

#Generate ssh-keygen for hduser
ssh-keygen -t rsa -P ""

#Copy id_rsa.pub to authorizedkeys from hduser
cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys

#Setup Hadoop enviornmental variables 
echo \# -- HADOOP ENVIRONMENT VARIABLES START -- \# >> $HOME/.bashrc
echo export JAVA_HOME=/usr/lib/jvm/java-8-oracle >> $HOME/.bashrc
echo export HADOOP_HOME=/usr/local/hadoop >> $HOME/.bashrc
echo export PATH=\$PATH:\$HADOOP_HOME/bin >> $HOME/.bashrc
echo export PATH=\$PATH:\$HADOOP_HOME/sbin >> $HOME/.bashrc
echo export HADOOP_MAPRED_HOME=\$HADOOP_HOME >> $HOME/.bashrc
echo export HADOOP_COMMON_HOME=\$HADOOP_HOME >> $HOME/.bashrc
echo export HADOOP_HDFS_HOME=\$HADOOP_HOME >> $HOME/.bashrc
echo export YARN_HOME=\$HADOOP_HOME >> $HOME/.bashrc
echo export HADOOP_COMMON_LIB_NATIVE_DIR=\$HADOOP_HOME/lib/native >> $HOME/.bashrc
echo export HADOOP_OPTS=\"-Djava.library.path=$HADOOP_HOME/lib\" >> $HOME/.bashrc
echo \# -- HADOOP ENVIRONMENT VARIABLES END -- \# >> $HOME/.bashrc

#Change Directoy to /usr/local
cd /usr/local/

#Download hadoop from source
sudo wget http://apache.mirrors.tds.net/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz

#Extract tar file
sudo tar -xzf hadoop-2.4.0.tar.gz 

#Rename hadoop folder 
sudo mv hadoop-2.6.0 hadoop

echo "#The java implementation to use" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh
echo export JAVA_HOME=/usr/bin/java >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh

echo "#The hadoop implementation to use" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh
echo export HADOOP_PREFIX=/usr/local/hadoop






