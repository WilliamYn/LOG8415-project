# LOG8415-project
Final project for the course

Commands to run

Standalone:

*   cd ../../project
*   sudo mysql -u root
*   SOURCE ~/../../project/sakila-db/sakila-schema.sql;
*   SOURCE ~/../../project/sakila-db/sakila-data.sql;
*   exit

Run benchmarks:

// read
*   sudo sysbench oltp_read_only --table-size=100000 --db-driver=mysql --mysql-db=sakila --mysql-user=root prepare
*   sudo sysbench oltp_read_only --table-size=100000 --db-driver=mysql --mysql-db=sakila --mysql-user=root --num-threads=6 --max-time=60 --max-requests=0 run
*   sudo sysbench oltp_read_only --table-size=100000 --db-driver=mysql --mysql-db=sakila --mysql-user=root cleanup

// write
*   sudo sysbench oltp_write_only --table-size=100000 --db-driver=mysql --mysql-db=sakila --mysql-user=root prepare
*   sudo sysbench oltp_write_only --table-size=100000 --db-driver=mysql --mysql-db=sakila --mysql-user=root --num-threads=6 --max-time=60 --max-requests=0 run
*   sudo sysbench oltp_write_only --table-size=100000 --db-driver=mysql --mysql-db=sakila --mysql-user=root cleanup

// read write
*   sudo sysbench oltp_read_write --table-size=100000 --db-driver=mysql --mysql-db=sakila --mysql-user=root prepare
*   sudo sysbench oltp_read_write --table-size=100000 --db-driver=mysql --mysql-db=sakila --mysql-user=root --num-threads=6 --max-time=60 --max-requests=0 run
*   sudo sysbench oltp_read_write --table-size=100000 --db-driver=mysql --mysql-db=sakila --mysql-user=root cleanup

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
*   exit

benchmarks:
// read:
*   sudo sysbench oltp_read_only --table-size=100000 --db-driver=mysql --mysql-db=sakila --mysql-user=root --mysql_storage_engine=ndbcluster prepare
*   sudo sysbench oltp_read_only --table-size=100000 --db-driver=mysql --mysql-db=sakila --mysql-user=root --mysql_storage_engine=ndbcluster --num-threads=6 --max-time=60 --max-requests=0 run
*   sudo sysbench oltp_read_only --table-size=100000 --db-driver=mysql --mysql-db=sakila --mysql-user=root --mysql_storage_engine=ndbcluster cleanup

// write:
*   sudo sysbench oltp_write_only --table-size=100000 --db-driver=mysql --mysql-db=sakila --mysql-user=root --mysql_storage_engine=ndbcluster prepare
*   sudo sysbench oltp_write_only --table-size=100000 --db-driver=mysql --mysql-db=sakila --mysql-user=root --mysql_storage_engine=ndbcluster --num-threads=6 --max-time=60 --max-requests=0 run
*   sudo sysbench oltp_write_only --table-size=100000 --db-driver=mysql --mysql-db=sakila --mysql-user=root --mysql_storage_engine=ndbcluster cleanup

// read-write:
*   sudo sysbench oltp_read_write --table-size=100000 --db-driver=mysql --mysql-db=sakila --mysql-user=root --mysql_storage_engine=ndbcluster prepare
*   sudo sysbench oltp_read_write --table-size=100000 --db-driver=mysql --mysql-db=sakila --mysql-user=root --mysql_storage_engine=ndbcluster --num-threads=6 --max-time=60 --max-requests=0 run
*   sudo sysbench oltp_read_write --table-size=100000 --db-driver=mysql --mysql-db=sakila --mysql-user=root --mysql_storage_engine=ndbcluster cleanup



Reference for setup of mysql cluster: https://www.digitalocean.com/community/tutorials/how-to-create-a-multi-node-mysql-cluster-on-ubuntu-18-04
Reference for sysbench: https://www.jamescoyle.net/how-to/1131-benchmark-mysql-server-performance-with-sysbench 
