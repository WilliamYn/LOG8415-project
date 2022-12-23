#!/bin/bash
# Python and pip installation
sudo apt-get update
sudo apt-get install -y python3
sudo apt-get install -y python3-pip
# Installation of libraries needed in proxy script
sudo pip install pythonping
sudo pip install sshtunnel
sudo pip install pymysql