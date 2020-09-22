#!/bin/bash

currentDir=$(pwd)
currentMachineIP=$(hostname -I)

echo "======================================================"
echo "INSTALLING REDIS STABLE"
echo "======================================================"

# Download redis files
sudo cd /tmp
sudo curl -O http://download.redis.io/redis-stable.tar.gz
sudo tar xzvf redis-stable.tar.gz
cd redis-stable

echo "======================================================"
echo "MAKE REDIS"
echo "======================================================"

# Compile redis sourc
sudo make
sudo make test
sudo cd src/
sudo make test
sudo make install

echo "======================================================"
echo "SET SETTING SYSCTL.CONF"
echo "======================================================"

# Redis Memeory and user config
sudo echo "vm.overcommit_memory=1" >> /etc/sysctl.conf 
sudo echo "net.core.somaxconn=65535" >> /etc/sysctl.conf 
cd $currentDir
sudo  yes | cp -rf conf/etc/rc.local /etc/
sudo adduser --system --group --no-create-home redis


echo "======================================================"
echo "CREATING LOG FILES AND ADDING PERMISSION"
echo "======================================================"

# Create redis folder and log file for redis
# Add permissions for redis folders 
sudo mkdir -p /etc/redis

sudo mkdir -p /var/log/redis/
sudo touch /var/log/redis/redis.log
sudo chown redis:redis /var/log/redis/redis.log

sudo mkdir /var/lib/redis
sudo chown redis:redis /var/lib/redis
sudo chmod 770 /var/lib/redis


sudo cp conf/service/redis-server.service /etc/systemd/system/redis-server.service

#If master ip equals to current ip then currently machine is master machine
echo "======================================================"
echo "SERVICE STARTING..."
echo "======================================================"
sudo yes | cp conf/redis.conf /etc/redis/redis.conf


sudo systemctl start redis-server
#sudo systemctl status redis-server
sudo systemctl enable redis-server

systemctl daemon-reload

sudo systemctl restart redis-server

#reboot
