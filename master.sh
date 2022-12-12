#!/bin/bash
echo "master"
sudo apt-get update
sudo apt-get -y install git dos2unix libaio1 libmecab2 sysbench expect libncurses5 libtinfo5

# cd ../..
sudo mkdir project
cd project

sudo wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.6/mysql-cluster-community-management-server_7.6.6-1ubuntu18.04_amd64.deb
sudo dpkg -i mysql-cluster-community-management-server_7.6.6-1ubuntu18.04_amd64.deb


# config ini
sudo touch config.ini
echo -e -E "[ndbd default]
NoOfReplicas=3

[ndb_mgmd]
# Management process options:
hostname=ip-172-31-17-1.ec2.internal
datadir=/var/lib/mysql-cluster
NodeId=1

[ndbd]
hostname=ip-172-31-17-2.ec2.internal
NodeId=2
datadir=/usr/local/mysql/data

[ndbd]
hostname=ip-172-31-17-3.ec2.internal
NodeId=3
datadir=/usr/local/mysql/data

[ndbd]
hostname=ip-172-31-17-4.ec2.internal
NodeId=4
datadir=/usr/local/mysql/data


[mysqld]
# SQL node options:
hostname=ip-172-31-17-1.ec2.internal
NodeId=11

[mysqld]
hostname=ip-172-31-17-2.ec2.internal
NodeId=12

[mysqld]
hostname=ip-172-31-17-3.ec2.internal
NodeId=13

[mysqld]
hostname=ip-172-31-17-4.ec2.internal
NodeId=14" | sudo tee config.ini
sudo dos2unix config.ini
sudo mkdir /var/lib/mysql-cluster #TODO
sudo cp config.ini /var/lib/mysql-cluster/
