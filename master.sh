#!/bin/bash
echo "master"
sudo apt-get update
sudo apt-get -y install git dos2unix libaio1 libmecab2 sysbench expect libncurses5 libtinfo5

# cd ../..
sudo mkdir project
cd project

sudo wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.6/mysql-cluster-community-management-server_7.6.6-1ubuntu18.04_amd64.deb
sudo dpkg -i mysql-cluster-community-management-server_7.6.6-1ubuntu18.04_amd64.deb


