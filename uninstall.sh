#!/bin/bash

if [ ! -f scripts/clean_up.sh ] ; then
        echo ""
        echo "clean_ip.sh file is missing."
        exit 1;
fi

echo ""
echo "Do you waant to proceed with uninstallation ? [y/n]"
read answer

if [ $answer == "n" ] || [ $answer == "N" ] ; then
	exit 0
fi

if [ -f config/rc.conf ] ; then

        if [ ! -z $CONFIG_COMPUTE_HOST ] ; then
                echo ""
                echo "Uninstalling openstack on compute node."

                # scp the clean up scrip to the compute node.
                scp scripts/clean_up.sh root@$CONFIG_CONTROLLER_HOST:/root/

# run clean up script by doing SSH to the node.
ssh root@$CONFIG_CONTROLLER_HOST <<ENDSSH1
	source /root/clean_up.sh
ENDSSH1

        fi

        if [ ! -z $CONFIG_NETWORK_HOST ] ; then
                echo ""
                echo "Uninstalling openstack on network node."

                # scp the clean up scrip to the network node.
                scp scripts/clean_up.sh root@$CONFIG_NETWORK_HOST:/root/

# run clean up script by doing SSH to the node.
ssh root@$CONFIG_NETWORK_HOST <<-ENDSSH2
	source /root/clean_up.sh
ENDSSH2
        fi
		
		
        if [ ! -z $CONFIG_STORAGE_HOST ] ; then
                echo ""
                echo "Uninstalling openstack on storage node."

                # scp the clean up scrip to the controller node.
                scp scripts/clean_up.sh root@$CONFIG_CONTROLLER_HOST:/root/

# run clean up script by doing SSH to the node.
ssh root@$CONFIG_CONTROLLER_HOST <<ENDSSH3
source /root/clean_up.sh
ENDSSH3
        fi

        echo ""
        echo "Uninstalling openstack on controller node."
        source scripts/clean_up.sh
else
        echo ""
        echo "Uninstalling openstack --allinone."
        source scripts/clean_up.sh
fi

echo ""
echo "Sucessfully Uninstalled Openstack."
