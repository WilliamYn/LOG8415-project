#!/bin/bash
sudo apt-get update
sudo apt-get install -y mysql-server sysbench

mkdir project
cd project

wget https://downloads.mysql.com/docs/sakila-db.tar.gz
tar -xvf sakila-db.tar.gz

sudo mysql -u root -e "
SOURCE ~/../../project/sakila-db/sakila-schema.sql;
SOURCE ~/../../project/sakila-db/sakila-data.sql;
"