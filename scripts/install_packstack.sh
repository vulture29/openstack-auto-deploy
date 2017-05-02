#!/bin/bash

function generate_answer_file()
{
	echo ""
	echo "--> Generating deafult answer file."
	echo ""
	local tempFile=$(mktemp)
	packstack --gen-answer-file=$tempFile
	
	# disable some service by default
	sed -i "s/^CONFIG_CEILOMETER_INSTALL.*$/CONFIG_CEILOMETER_INSTALL=n/g" "$DEFAULT_CONFIG_PATH"
	sed -i "s/^CONFIG_AODH_INSTALL.*$/CONFIG_AODH_INSTALL=n/g" "$DEFAULT_CONFIG_PATH"
	sed -i "s/^CONFIG_GNOCCHI_INSTALL.*$/CONFIG_GNOCCHI_INSTALL=n/g" "$DEFAULT_CONFIG_PATH"

	cp -f $tempFile config/rc.conf.default
	cp -f $tempFile config/rc.conf
	rm -rf $tempFile
}

function install_packstack()
{
	# set language configuration
	echo ""
	echo "--> set language configuration."
	sed -i 's/LANG=en_US.utf-8/#LANG=en_US.utf-8/g' /etc/environment
	sed -i 's/LC_ALL=en_US.utf-8/#LC_ALL=en_US.utf-8/g' /etc/environment
	echo "LANG=en_US.utf-8" >> /etc/environment
	echo "LC_ALL=en_US.utf-8" >> /etc/environment

	# install packstack from the answer file
	# change the file name
	echo ""
	echo "--> Installing the packstack packages."
	yum remove centos-release-openstack-newton -y >/dev/null 2>&1 
	yum install -y centos-release-openstack-newton >/dev/null 2>&1;
	yum remove  openstack-packstack -y >/dev/null 2>&1 
	yum install -y openstack-packstack >/dev/null 2>&1;
}	

install_packstack
