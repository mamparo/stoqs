#!/usr/bin/env bash
# First we need to start by disabling the firewall. May not be needed for Vagrant
# Anytime the system is restarted in the install process this need to be done.
# su
# echo 0 > /selinux/enforce
yum install wget
# This commands will download and install the Epel and Yum to make installation easier
wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
rpm -Uvh remi-release-6*.rpm epel-release-6*.rpm
#Step 3
curl -O http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-centos93-9.3-1.noarch.rpm
rpm -ivh pgdg*
yum -y install postgresql93-server
service postgresql-9.3 initdb
chkconfig postgresql-9.3 on
service postgresql-9.3 start
yum -y groupinstall "PostgreSQL Database Server 9.3 PGDG"
chkconfig postgresql-9.3 on
su
# We need to enter the Bash enviroment to alter the logfile for postgres.
#su - postgres # Bash
#/usr/pgsql-9.3/bin/pg_ctl -D /var/lib/pgsql/9.3/data -l logfile start
#exit
#Step 5
#Install Mercurial
yum -y install mercurial

#Step 6 (This next line of code will be changed before Vagrant Project is finalized)
#Download and install from Google Code the clone of the STOQS file.
#older code before moving to gihub //hg clone https://code.google.com/p/stoqs/
#git clone https://github.com/stoqs/stoqs.git #This will be done later
git clone https://github.com/mamparo/stoqs.git
chown postgres stoqs

#Step 7
#Instal the Development Tools for PostGres
yum -y groupinstall 'Development Tools'

#Step 8
#Download and install CMake
wget http://www.cmake.org/files/v2.8/cmake-2.8.3.tar.gz
tar xzf cmake-2.8.3.tar.gz
cd cmake-2.8.3
./configure --prefix=/opt/cmake
gmake
make
make install
mkdir -m 700 build
cd ..

#Step 9
#Install Python, Virtual Enviroment, & Rabbit Server. This will also setup a user/host for stoqs.
#The credentials for user/host can be altered by user if needed.
yum -y install python-setuptools
su -c "easy_install virtualenv"
su -c "yum -y install rabbitmq-server scipy mod_wsgi memcached python-memcached"
su -c "/sbin/chkconfig rabbitmq-server on"
su -c "/sbin/service rabbitmq-server start"
su -c "rabbitmqctl add_user stoqs stoqs"
su -c "rabbitmqctl add_vhost stoqs"
su -c 'rabbitmqctl set_permissions -p stoqs stoqs ".*" ".*" ".*"'

#Step 10
# Install Graph for Mapping Software
su -c "yum -y install graphviz-devel"
su -c "yum -y install graphviz-python"

#Step 11
# Install ImageMagick image editor
su -c "yum -y install ImageMagick"
