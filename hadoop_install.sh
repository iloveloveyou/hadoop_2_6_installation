#Source: http://pingax.com/install-hadoop2-6-0-on-ubuntu/
#Install Java 8
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer -y

#Create a Hadoop user for accessing HDFS and MapReduce
sudo addgroup hadoop
sudo adduser --ingroup hadoop hduser
sudo adduser hduser sudo

#Install SSH
sudo apt-get install openssh-server

#Configure SSH
sudo su hduser
ssh-keygen -t rsa -P ""
cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys

#Disable IPV6
sudo su -c 'cat >>/etc/sysctl.conf <<EOL
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOL'


#Download Hadoop

#Navigate to hadoop installation directory
cd /usr/local/

#Download Hadoop
sudo wget http://apache.mirrors.tds.net/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz

#Extract Hadoop source 
sudo tar -xzvf hadoop-2.6.0.tar.gz

sudo mv hadoop-2.6.0 /usr/local/hadoop 

sudo chown hduser:hadoop -R /usr/local/hadoop 

sudo mkdir -p /usr/local/hadoop_tmp/hdfs/namenode
sudo mkdir -p /usr/local/hadoop_tmp/hdfs/datanode

sudo chown hduser:hadoop -R /usr/local/hadoop_tmp/

#Update Hadoop configuration files
cat >>$HOME/.bashrc <<EOL
# -- HADOOP ENVIRONMENT VARIABLES START -- #
export JAVA_HOME=/usr/lib/jvm/java-8-oracle
export HADOOP_HOME=/usr/local/hadoop
export PATH=$PATH:$HADOOP_HOME/bin
export PATH=$PATH:$HADOOP_HOME/sbin
export PATH=$PATH:/usr/local/hadoop/bin/
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"
# -- HADOOP ENVIRONMENT VARIABLES END -- #
EOL

#Update hadoop-env.sh
echo JAVA_HOME=/usr/lib/jvm/java-8-oracle >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh

#Update core-site.xml
#Remove configuration tag
sudo sed -i '/<configuration>/,/<\/configuration>/d' /usr/local/hadoop/etc/hadoop/core-site.xml

cat >>/usr/local/hadoop/etc/hadoop/core-site.xml <<EOL
<configuration>
	<property>
		<name>fs.default.name</name>
		<value>hdfs://localhost:9000</value>
	</property>
</configuration>
EOL

#Update hdfs-site.xml
#Remove configuration tag
sudo sed -i '/<configuration>/,/<\/configuration>/d' /usr/local/hadoop/etc/hadoop/hdfs-site.xml

cat >>/usr/local/hadoop/etc/hadoop/hdfs-site.xml <<EOL
<configuration>
	<property>
	      <name>dfs.replication</name>
	      <value>1</value>
	 </property>
 	<property>
	      <name>dfs.namenode.name.dir</name>
	      <value>file:/usr/local/hadoop_tmp/hdfs/namenode</value>
	 </property>
	 <property>
	      <name>dfs.datanode.data.dir</name>
	      <value>file:/usr/local/hadoop_tmp/hdfs/datanode</value>
	 </property>
</configuration>
EOL

#Update yarn-site.xml
#Remove configuration tag
sudo sed -i '/<configuration>/,/<\/configuration>/d' /usr/local/hadoop/etc/hadoop/yarn-site.xml

cat >>/usr/local/hadoop/etc/hadoop/yarn-site.xml <<EOL
<configuration>
	<property>
	      <name>yarn.nodemanager.aux-services</name>
	      <value>mapreduce_shuffle</value>
	</property>
	<property>
	      <name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
	      <value>org.apache.hadoop.mapred.ShuffleHandler</value>
	</property>
</configuration>
EOL

#Update mapred-site.xml
#Remove configuration tag
sudo sed -i '/<configuration>/,/<\/configuration>/d' /usr/local/hadoop/etc/hadoop/mapred-site.xml

cat >>/usr/local/hadoop/etc/hadoop/mapred-site.xml <<EOL
<configuration>
	<property>
	      <name>mapreduce.framework.name</name>
	      <value>yarn</value>
	</property>
</configuration>
EOL

#Format Namenode
hdfs namenode -format

#Start all Hadoop daemons

#Start dfs
cd /usr/local/hadoop/sbin/
./start-dfs.sh

#Start yarn
cd /usr/local/hadoop/sbin/
./start-yarn.sh

jps




