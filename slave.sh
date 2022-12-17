#!/bin/bash
echo "HELLOOOOOO"
sudo apt-get update
sudo apt-get -y install libclass-methodmaker-perl git dos2unix expect libaio1 libmecab2

sudo mkdir project
cd project

sudo wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.6/mysql-cluster-community-data-node_7.6.6-1ubuntu18.04_amd64.deb
sudo dpkg -i mysql-cluster-community-data-node_7.6.6-1ubuntu18.04_amd64.deb

# Create my.cnf:
sudo touch my.cnf
echo -e -E "[mysql_cluster]
ndb-connectstring=ip-172-31-17-1.ec2.internal  # Master server" | sudo tee my.cnf
sudo dos2unix my.cnf
sudo cp my.cnf /etc/

sudo mkdir -p /usr/local/mysql/data # TODO

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

sudo dos2unix ndbd.service
sudo cp ndbd.service /etc/systemd/system/

sudo systemctl daemon-reload
sudo systemctl enable ndbd
sudo systemctl start ndbd