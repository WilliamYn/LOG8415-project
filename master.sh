#!/bin/bash
# Installations
sudo apt-get update
sudo apt-get -y install libaio1 libmecab2 libncurses5 libtinfo5 sysbench

# Create project directory
sudo mkdir project
cd project

# Install ndb_mgmd --> management node for MySQL cluster
sudo wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.6/mysql-cluster-community-management-server_7.6.6-1ubuntu18.04_amd64.deb
sudo dpkg -i mysql-cluster-community-management-server_7.6.6-1ubuntu18.04_amd64.deb

# Creation of configuration file for the cluster manager
sudo touch config.ini
echo -e -E "[ndbd default]
NoOfReplicas=3                          # We have 3 slaves connected to our management node in our cluster

[ndb_mgmd]
# Management process options:
hostname=ip-172-31-17-1.ec2.internal    # Ip address of master node
datadir=/var/lib/mysql-cluster
NodeId=1

[ndbd]
hostname=ip-172-31-17-2.ec2.internal    # Ip address of first slave node
NodeId=2
datadir=/usr/local/mysql/data

[ndbd]
hostname=ip-172-31-17-3.ec2.internal    # Ip address of second slave node
NodeId=3
datadir=/usr/local/mysql/data

[ndbd]
hostname=ip-172-31-17-4.ec2.internal    # Ip address of third slave node
NodeId=4
datadir=/usr/local/mysql/data


[mysqld]
# SQL node options:
hostname=ip-172-31-17-1.ec2.internal
NodeId=5

[mysqld]
hostname=ip-172-31-17-2.ec2.internal
NodeId=6

[mysqld]
hostname=ip-172-31-17-3.ec2.internal
NodeId=7

[mysqld]
hostname=ip-172-31-17-4.ec2.internal
NodeId=8" | sudo tee config.ini
sudo mkdir /var/lib/mysql-cluster
sudo cp config.ini /var/lib/mysql-cluster/

# Creation of ndb_mgmd service file to start cluster management server with configuration of config.ini when instance starts
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
sudo cp ndb_mgmd.service /etc/systemd/system/

# Enable and start the ndb_mgmd service
echo "reload"
sudo systemctl daemon-reload
echo "enable"
sudo systemctl enable ndb_mgmd
echo "start"
sudo systemctl start ndb_mgmd

# Installation of dependencies
wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.6/mysql-cluster_7.6.6-1ubuntu18.04_amd64.deb-bundle.tar
sudo tar -xvf mysql-cluster_7.6.6-1ubuntu18.04_amd64.deb-bundle.tar
sudo dpkg -i mysql-common_7.6.6-1ubuntu18.04_amd64.deb
sudo dpkg -i mysql-cluster-community-client_7.6.6-1ubuntu18.04_amd64.deb
sudo dpkg -i mysql-client_7.6.6-1ubuntu18.04_amd64.deb

# Creation of configuration file for MySQL server installation
sudo touch my.cnf
echo "
[mysqld]
ndbcluster
bind-address=0.0.0.0
ndb-connectstring=ip-172-31-17-1.ec2.internal

[mysql_cluster]
ndb-connectstring=ip-172-31-17-1.ec2.internal       # IP of master node
" | sudo tee my.cnf
