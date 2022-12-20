#!/bin/bash
echo "master"
sudo apt-get update
sudo apt-get -y install libaio1 libmecab2 libncurses5 libtinfo5 dos2unix sysbench # TODO

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

# service
sudo touch ndb_mgmd.service
echo -e -E "[Unit]
Description=MySQL NDB Cluster Management Server
After=network.target auditd.service

[Service]
Type=forking
ExecStart=/usr/sbin/ndb_mgmd -f /var/lib/mysql-cluster/config.ini
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target" | sudo tee ndb_mgmd.service
sudo dos2unix ndb_mgmd.service
sudo cp ndb_mgmd.service /etc/systemd/system/

echo "reload"
sudo systemctl daemon-reload
echo "enable"
sudo systemctl enable ndb_mgmd
echo "start"
sudo systemctl start ndb_mgmd

# Install mysql cluster and install packages from debian files
wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.6/mysql-cluster_7.6.6-1ubuntu18.04_amd64.deb-bundle.tar
sudo tar -xvf mysql-cluster_7.6.6-1ubuntu18.04_amd64.deb-bundle.tar
sudo dpkg -i mysql-common_7.6.6-1ubuntu18.04_amd64.deb
sudo dpkg -i mysql-cluster-community-client_7.6.6-1ubuntu18.04_amd64.deb
sudo dpkg -i mysql-client_7.6.6-1ubuntu18.04_amd64.deb

# Create my.cnf file
sudo touch my.cnf
echo "
[mysqld]
ndbcluster
bind-address=0.0.0.0
ndb-connectstring=ip-172-31-17-1.ec2.internal

[mysql_cluster]
ndb-connectstring=ip-172-31-17-1.ec2.internal
" | sudo tee my.cnf