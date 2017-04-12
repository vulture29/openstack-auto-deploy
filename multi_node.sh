#!/bin/bash

export PATH=$PATH:/sbin/:/usr/bin/:/bin/

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 2
fi

# clean up step
if [ -f clean_up.sh ] ; then 
	source clean_up.sh
	clean_up
else
	echo ""
	echo "Clean up script is missing."
	exit 1
fi

# Network Health Checkup step
if [ -f network_health_checkup.sh ] ; then 
	source network_health_checkup.sh
	network_health_checkup
else
	echo ""
	echo "Network Health Checkup script is missing."
	exit 1
fi

# packstack installation
# set language configuration
echo ""
echo "set language configuration..."
sed -i 's/LANG=en_US.utf-8/#LANG=en_US.utf-8/g' /etc/environment
sed -i 's/LC_ALL=en_US.utf-8/#LC_ALL=en_US.utf-8/g' /etc/environment
echo "LANG=en_US.utf-8" >> /etc/environment
echo "LC_ALL=en_US.utf-8" >> /etc/environment

# install packstack from the answer file
# change the file name
echo ""
echo "installing the packstack packages..."
yum install -y centos-release-openstack-newton >/dev/null 2>&1;
yum update -y >/dev/null 2>&1;
yum install -y openstack-packstack >/dev/null 2>&1;
echo ""
packstack --answer-file=FILE
