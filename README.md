# LOG8415-project
Final project for the course

Commands to run

Standalone:

*   cd ../../project
*   sudo mysql -u root
*   SOURCE ~/../../project/sakila-db/sakila-schema.sql;
*   SOURCE ~/../../project/sakila-db/sakila-data.sql;
*   exit

Cluster setup
On master:
*   cd ../../project
*   sudo dpkg -i mysql-cluster-community-server_7.6.6-1ubuntu18.04_amd64.deb
*   sudo dpkg -i mysql-server_7.6.6-1ubuntu18.04_amd64.deb
*   sudo cp my.cnf /etc/mysql/my.cnf

*   sudo systemctl restart mysql
*   sudo systemctl enable mysql


Install sakila
*   sudo wget https://downloads.mysql.com/docs/sakila-db.tar.gz
*   sudo tar -xvf sakila-db.tar.gz
*   sudo mysql -u root
*   SOURCE ~/../../project/sakila-db/sakila-schema.sql;
*   SOURCE ~/../../project/sakila-db/sakila-data.sql;
*   exit

// check if works
*   sudo systemctl status ndb_mgmd
*   ndb_mgm
*   show
*   exit

// to see if sakila installed:
*   sudo mysql
*   use sakila;
*   show tables;
*   SELECT * FROM store;
*   exit


Proxy
- in proxy:
sudo nano proxy.py
- paste this code
sudo nano vockey.pem
- get RSA key from AWS details, paste in vockey.pem
sudo chmod 400 vockey.pem
sudo python3 proxy.py

IN MASTER:
sudo mysql -u root
GRANT ALL ON *.* to root@'34.227.47.103' IDENTIFIED BY 'password'; #TODO change IP
GRANT ALL ON *.* to 'user'@'34.227.47.103' IDENTIFIED BY 'password'; #TODO change IP