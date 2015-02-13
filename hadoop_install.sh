#!/bin/bash
#Java Installation Source: http://www.webupd8.org/2012/09/install-oracle-java-8-in-ubuntu-via-ppa.html

#Add java 8 repository
sudo add-apt-repository ppa:webupd8team/java

#Update repository
sudo apt-get update

#Setup Automated Installation
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections

#Install Java 7
sudo apt-get install oracle-java8-installer -y

#Change Directoy to /usr/local
cd /usr/local/

#Downlo hadoop from source
sudo wget http://apache.mirrors.tds.net/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz
