#!/bin/bash

function install_packstack()
{
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
	yum remove centos-release-openstack-newton -y >/dev/null 2>&1 
	yum install -y centos-release-openstack-newton >/dev/null 2>&1;
	yum update -y >/dev/null 2>&1;
	yum remove  openstack-packstack -y >/dev/null 2>&1 
	yum install -y openstack-packstack >/dev/null 2>&1;
	echo ""
	packstack --answer-file=$1
}