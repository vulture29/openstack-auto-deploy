#!/bin/bash

export PATH=$PATH:/sbin/:/usr/bin/:/bin/

# modify the config file path
CONFIG_FILE_PATH="config/rc.conf.default"

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 2
fi

# user config step
if [ -f scripts/user_config.sh ] ; then 
	source scripts/user_config.sh
else
	echo ""
	echo "User config script is missing."
	exit 1
fi

# clean up step
if [ -f scripts/clean_up.sh ] ; then 
	source scripts/clean_up.sh
else
	echo ""
	echo "Clean up script is missing."
	exit 1
fi

# Network Health Checkup step
if [ -f scripts/network_health_checkup.sh ] ; then 
	source scripts/network_health_checkup.sh
else
	echo ""
	echo "Network Health Checkup script is missing."
	exit 1
fi

# Prerequisite Checkup step
if [ -f scripts/prerequisites.sh ] ; then 
	source scripts/prerequisites.sh
else
	echo ""
	echo "Prerequisites Checkup script is missing."
	exit 1
fi


# packstack installation
if [ -f scripts/install_openstack.sh ] ; then 
	source scripts/install_openstack.sh
	install_openstack $CONFIG_FILE_PATH
else
	echo ""
	echo "Packstack installation script is missing."
	exit 1
fi
