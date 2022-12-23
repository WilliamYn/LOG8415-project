#!/bin/bash
# Installation of sysbench and mysql-server
sudo apt-get update
sudo apt-get install -y sysbench mysql-server

# Create project directory
mkdir project
cd project

# Install and extract sakila 
wget https://downloads.mysql.com/docs/sakila-db.tar.gz
tar -xvf sakila-db.tar.gz