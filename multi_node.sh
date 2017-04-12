#!/bin/bash

export PATH=$PATH:/sbin/:/usr/bin/:/bin/

# modify the config file path
CONFIG_FILE="/usr/local/openstack/config"

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
if [ -f install_packstack.sh ] ; then 
	source install_packstack.sh
	install_packstack $CONFIG_FILE
else
	echo ""
	echo "Packstack installation script is missing."
	exit 1
fi
