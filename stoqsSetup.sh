#!/bin/bash
sudo yum update -y
sudo yum install gcc kernel-devel kernel-headers dkms make bzip2 perl
yum install kernel-devel-2.6.32-431.3.1.e16.x86_64
sudo ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
# First we need to start by disabling the firewall. May not be needed for Vagrant
# Anytime the system is restarted in the install process this need to be done.
su
echo 0 > /selinux/enforce
# This commands will download and install the Epel and Yum to make installation easier
wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
rpm -Uvh remi-release-6*.rpm epel-release-6*.rpm
# We need to enter the Bash enviroment to alter the logfile for postgres.
su -c "su - postgres" # Bash
/usr/pgsql-9.3/bin/pg_ctl -D /var/lib/pgsql/9.3/data -l logfile start
exit
