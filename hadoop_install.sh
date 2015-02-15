#!/bin/bash
#hadoop installation Source: http://pingax.com/install-hadoop2-6-0-on-ubuntu/
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

#Login in with hduser
sudo su hduser


#Disable IPV6
echo net.ipv6.conf.all.disable_ipv6 = 1 >> /etc/sysctl.conf
echo net.ipv6.conf.default.disable_ipv6 = 1 >> /etc/sysctl.conf
echo net.ipv6.conf.lo.disable_ipv6 = 1 >> /etc/sysctl.conf

#Edit core-site.xml
#Remove configuration tag 
sudo sed -i '/<configuration>/,/<\/configuration>/d' /usr/local/hadoop/etc/hadoop/core-site.xml

#Add new configuration
echo "<configuration>" >> /usr/local/hadoop/etc/hadoop/core-site.xml
echo  "<property>" >> /usr/local/hadoop/etc/hadoop/core-site.xml
echo    "<name>fs.default.name</name>" >> /usr/local/hadoop/etc/hadoop/core-site.xml
echo    "<value>hdfs://localhost:9000</value>" >> /usr/local/hadoop/etc/hadoop/core-site.xml
echo  "</property>" >> /usr/local/hadoop/etc/hadoop/core-site.xml
echo "</configuration>" >> /usr/local/hadoop/etc/hadoop/core-site.xml

#Edit hdfs-site.xml
#Remove configuration tag 
sudo sed -i '/<configuration>/,/<\/configuration>/d' /usr/local/hadoop/etc/hadoop/hdfs-site.xml

#Add new configuration
echo "<configuration>" >> /usr/local/hadoop/etc/hadoop/hdfs-site.xml
echo  "<propery>" >> /usr/local/hadoop/etc/hadoop/hdfs-site.xml
echo   "<name>dfs.replication</name>" >> /usr/local/hadoop/etc/hadoop/hdfs-site.xml
echo   "<value>1</value>" >> /usr/local/hadoop/etc/hadoop/hdfs-site.xml
echo  "</propery>" >> /usr/local/hadoop/etc/hadoop/hdfs-site.xml
echo  "<propery"> >> /usr/local/hadoop/etc/hadoop/hdfs-site.xml
echo   "<name>dfs.namenode.name.dir</name>" >> /usr/local/hadoop/etc/hadoop/hdfs-site.xml
echo   "<value>file:/usr/local/hadoop_tmp/hdfs/namenode</value>" >> /usr/local/hadoop/etc/hadoop/hdfs-site.xml>> /usr/local/hadoop/etc/hadoop/hdfs-site.xml
echo  "</propery>" >> /usr/local/hadoop/etc/hadoop/hdfs-site.xml 
echo  "<property>" >> /usr/local/hadoop/etc/hadoop/hdfs-site.xml
echo    "<name>dfs.datanode.data.dir</name>" >> >> /usr/local/hadoop/etc/hadoop/hdfs-site.xml
echo    "<value>file:/usr/local/hadoop_tmp/hdfs/datanode</value>" >> /usr/local/hadoop/etc/hadoop/hdfs-site.xml
echo  "</property>" >> /usr/local/hadoop/etc/hadoop/hdfs-site.xml >>>>  /usr/local/hadoop/etc/hadoop/hdfs-site.xml
echo "</configuration>" >> /usr/local/hadoop/etc/hadoop/hdfs-site.xml

#Edit yarn-site.xml
#Remove configuration tag 
sudo sed -i '/<configuration>/,/<\/configuration>/d' /usr/local/hadoop/etc/hadoop/yarn-site.xml

echo "<configuration>" >> /usr/local/hadoop/etc/hadoop/yarn-site.xml
echo  "<propery>" >> /usr/local/hadoop/etc/hadoop/yarn-site.xml
echo   "<name>yarn.nodemanager.aux-services</name>" >> /usr/local/hadoop/etc/hadoop/yarn-site.xml
echo   "<value>mapreduce_shuffle</value>" >> /usr/local/hadoop/etc/hadoop/yarn-site.xml
echo  "</propery>" >> /usr/local/hadoop/etc/hadoop/yarn-site.xml
echo  "<propery>" >> /usr/local/hadoop/etc/hadoop/yarn-site.xml
echo   "<name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>" >> /usr/local/hadoop/etc/hadoop/yarn-site.xml
echo   "<value>org.apache.hadoop.mapred.ShuffleHandler</value>" >> /usr/local/hadoop/etc/hadoop/yarn-site.xml
echo  "</propery>" >> /usr/local/hadoop/etc/hadoop/yarn-site.xml
echo "</configuration>" >> /usr/local/hadoop/etc/hadoop/yarn-site.xml

#Create mapred-site.xml from mapred-site.xml.template
cp /usr/local/hadoop/etc/hadoop/mapred-site.xml.template /usr/local/hadoop/etc/hadoop/mapred-site.xml

#Edit mapred-site.xml
#Remove configuration tag 
sudo sed -i '/<configuration>/,/<\/configuration>/d' /usr/local/hadoop/etc/hadoop/mapred-site.xml
echo "<configuration>" >> /usr/local/hadoop/etc/hadoop/mapred-site.xml
echo  "<propery>" >> /usr/local/hadoop/etc/hadoop/mapred-site.xml
echo   "<name>mapreduce.framework.name</name>" >> /usr/local/hadoop/etc/hadoop/mapred-site.xml
echo   "<value>yarn</value>" >> /usr/local/hadoop/etc/hadoop/mapred-site.xml
echo  "</propery>" >> /usr/local/hadoop/etc/hadoop/mapred-site.xml
echo "</configuration>" >> /usr/local/hadoop/etc/hadoop/mapred-site.xml

#Generate ssh-keygen for hduser
ssh-keygen -t rsa -P ""

#Copy id_rsa.pub to authorizedkeys from hduser
cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys

#Setup Hadoop enviornmental variables 
echo \# -- HADOOP ENVIRONMENT VARIABLES START -- \# >> $HOME/.bashrc
echo export JAVA_HOME=/usr/lib/jvm/java-8-oracle >> $HOME/.bashrc
echo export HADOOP_HOME=/usr/local/hadoop >> $HOME/.bashrc
echo export PATH=\$PATH:\$HADOOP_HOME/bin >> $HOME/.bashrc
echo export PATH=\$PATH:\$HADOOP_HOME/sbin >> $HOME/.bashrc   <property>echo
" <name>dfs"".datanode.data.dir</nameecho >
"   <value>file:/usr/local/hadoop_tmp/hdfs/datanode</value>echo"
"</property>"echo   "echo export" HADOOP_MAPRED_HOME=\$HADOOP_HOME >> $HOME/.bashrc
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

#Format namenode
hduser@pingax:hdfs namenode -format

#Start dfs
start-dfs.sh

#Start yarn
start-yarn.sh




