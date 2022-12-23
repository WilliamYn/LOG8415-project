# LOG8415-project

## MySQL Standalone commands to run:
*   cd ../../project
*   sudo mysql -u root
*   SOURCE ~/../../project/sakila-db/sakila-schema.sql;
*   SOURCE ~/../../project/sakila-db/sakila-data.sql;
*   exit

## MySQL Cluster commands to run:
### On Master node:
*   cd ../../project
*   sudo dpkg -i mysql-cluster-community-server_7.6.6-1ubuntu18.04_amd64.deb
*   sudo dpkg -i mysql-server_7.6.6-1ubuntu18.04_amd64.deb
*   sudo cp my.cnf /etc/mysql/my.cnf
*   sudo systemctl restart mysql
*   sudo systemctl enable mysql

Install sakila:
*   sudo wget https://downloads.mysql.com/docs/sakila-db.tar.gz
*   sudo tar -xvf sakila-db.tar.gz
*   sudo mysql -u root
*   SOURCE ~/../../project/sakila-db/sakila-schema.sql;
*   SOURCE ~/../../project/sakila-db/sakila-data.sql;
*   exit

Check if works:
*   sudo systemctl status ndb_mgmd
*   ndb_mgm
*   show
*   exit

Test sakila database:
*   sudo mysql
*   use sakila;
*   show tables;
*   SELECT * FROM store;
*   exit



## Proxy

### Commands to run in Master node:
Change the PROXY_PUBLIC_IP_ADDRESS for the public IP address of the proxy
*   sudo mysql -u root
*   GRANT ALL ON *.* to root@'PROXY_PUBLIC_IP_ADDRESS' IDENTIFIED BY 'password';
*   GRANT ALL ON *.* to 'user'@'PROXY_PUBLIC_IP_ADDRESS' IDENTIFIED BY 'password';

### Commands to run in Proxy node:
Get the proxy.py code from the Github and paste it here:
*   sudo nano proxy.py
Get RSA key from AWS details, paste in vockey.pem
*   sudo nano vockey.pem
*   sudo chmod 400 vockey.pem
*   sudo python3 proxy.py

