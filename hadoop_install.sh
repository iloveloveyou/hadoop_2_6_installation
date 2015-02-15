#Source: http://pingax.com/install-hadoop2-6-0-on-ubuntu/
#Install Java 8
echo "Installing Java 8"
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer -y

#Create a Hadoop user for accessing HDFS and MapReduce
echo "Create hadoop group and user"
sudo addgroup hadoop
sudo adduser --ingroup hadoop hduser
sudo adduser hduser sudo

#Install SSH
echo "install ssh"
sudo apt-get install openssh-server -y

#Configure SSH
echo "configure ssh"
sudo su hduser
ssh-keygen -t rsa -P ""
cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys

#Disable IPV6
echo "disable ipv6"
sudo su -c 'cat >>/etc/sysctl.conf <<EOL
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOL'


#Download Hadoop

#Navigate to hadoop installation directory
cd /usr/local/

#Download Hadoop
echo "download hadoop"
sudo wget http://apache.mirrors.tds.net/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz

#Extract Hadoop source
echo "extract hadoop"
sudo tar -xzvf hadoop-2.6.0.tar.gz

echo "rename hadoop folder"
sudo mv hadoop-2.6.0 /usr/local/hadoop 

echo "give overnership of hadoop folder to hduser"
sudo chown hduser:hadoop -R /usr/local/hadoop 

echo "make namenode and data noe directories"
sudo mkdir -p /usr/local/hadoop_tmp/hdfs/namenode
sudo mkdir -p /usr/local/hadoop_tmp/hdfs/datanode

echo "give ownership of hadoop tmp foler to hduser"
sudo chown hduser:hadoop -R /usr/local/hadoop_tmp/

#Update Hadoop configuration files
echo "write to .bashrc"
cat >>$HOME/.bashrc <<EOL
# -- HADOOP ENVIRONMENT VARIABLES START -- #
export JAVA_HOME=/usr/lib/jvm/java-8-oracle
export HADOOP_HOME=/usr/local/hadoop
export PATH=\$PATH:\$HADOOP_HOME/bin
export PATH=\$PATH:\$HADOOP_HOME/sbin
export PATH=\$PATH:/usr/local/hadoop/bin/
export HADOOP_MAPRED_HOME=\$HADOOP_HOME
export HADOOP_COMMON_HOME=\$HADOOP_HOME
export HADOOP_HDFS_HOME=\$HADOOP_HOME
export YARN_HOME=\$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=\$HADOOP_HOME/lib/native
export HADOOP_OPTS="-Djava.library.path=\$HADOOP_HOME/lib"
# -- HADOOP ENVIRONMENT VARIABLES END -- #
EOL

#Update hadoop-env.sh
echo "write to hadoop-env"
sudo su -c 'echo JAVA_HOME=/usr/lib/jvm/java-8-oracle >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh'

#Update core-site.xml
#Remove configuration tag

sudo su -c 'cat >>/usr/local/hadoop/etc/hadoop/core-site.xml <<EOL
echo "write to core-site.xml"
<configuration>
	<property>
		<name>fs.default.name</name>
		<value>hdfs://localhost:9000</value>
	</property>
</configuration>
EOL'

#Update hdfs-site.xml
#Remove configuration tag
#sudo sed -i '/<configuration>/,/<\/configuration>/d' /usr/local/hadoop/etc/hadoop/hdfs-site.xml
echo "Write to hdfs-site.xml"
sudo su -c 'cat >>/usr/local/hadoop/etc/hadoop/hdfs-site.xml <<EOL
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
EOL'

#Update yarn-site.xml
#Remove configuration tag
#sudo sed -i '/<configuration>/,/<\/configuration>/d' /usr/local/hadoop/etc/hadoop/yarn-site.xml

sudo su -c 'cat >>/usr/local/hadoop/etc/hadoop/yarn-site.xml <<EOL
echo "write to yarn-site.xml"
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
EOL'

#Update mapred-site.xml
#Remove configuration tag
#sudo sed -i '/<configuration>/,/<\/configuration>/d' /usr/local/hadoop/etc/hadoop/mapred-site.xml

echo "write to mapred-site.xml"
sudo su -c 'cat >>/usr/local/hadoop/etc/hadoop/mapred-site.xml <<EOL
<configuration>
	<property>
	      <name>mapreduce.framework.name</name>
	      <value>yarn</value>
	</property>
</configuration>
EOL'

#Format Namenode
echo "format namenode"
hdfs namenode -format

#Start all Hadoop daemons

#Start dfs
echo "start dfs"
cd /usr/local/hadoop/sbin/
./start-dfs.sh

#Start yarn
echo "start yarn"
cd /usr/local/hadoop/sbin/
./start-yarn.sh

echo "jps"
jps




