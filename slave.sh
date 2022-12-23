#!/bin/bash
# Installations
sudo apt-get update
sudo apt-get -y install libaio1 libmecab2 libclass-methodmaker-perl

# Create project directory
sudo mkdir project
cd project

# Fetch debian file for data node of sql cluster
sudo wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.6/mysql-cluster-community-data-node_7.6.6-1ubuntu18.04_amd64.deb
# Installation of the data node for sql cluster
sudo dpkg -i mysql-cluster-community-data-node_7.6.6-1ubuntu18.04_amd64.deb

# Creation of data node configuration file
sudo touch my.cnf
echo -e -E "[mysql_cluster]
ndb-connectstring=ip-172-31-17-1.ec2.internal  # IP address of master" | sudo tee my.cnf
sudo cp my.cnf /etc/

# Create data directory
sudo mkdir -p /usr/local/mysql/data

# Creation of ndbd service to give start instruction to run ndbd (data node)
sudo touch ndbd.service
echo -e -E "
[Unit]
Description=MySQL NDB Data Node Daemon
After=network.target auditd.service

[Service]
Type=forking
ExecStart=/usr/sbin/ndbd
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
" | sudo tee ndbd.service
sudo cp ndbd.service /etc/systemd/system/

# Enable and start ndbd service
sudo systemctl daemon-reload
sudo systemctl enable ndbd
sudo systemctl start ndbd