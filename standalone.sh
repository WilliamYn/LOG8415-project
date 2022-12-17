#!/bin/bash
echo "Installations"
sudo apt-get update
sudo apt-get install -y mysql-server sysbench

echo "Dir creation"
mkdir project
cd project

echo "Sakila install"
wget https://downloads.mysql.com/docs/sakila-db.tar.gz
tar -xvf sakila-db.tar.gz
