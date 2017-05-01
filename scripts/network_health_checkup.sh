#!/bin/bash

function network_health_checkup()
{
	## Reading from answers.txt file
	if [ -f "config/rc.conf.default" ] ; then
		source config/rc.conf.default >/dev/null 2>&1
	elif [ -f "config/rc.conf" ] ; then 
		source config/rc.conf >/dev/null 2>&1
	else
		echo ""
		echo "ERROR -- no file config file."
		exit 1
	fi

	## Check if all the nodes are reachable from controller
	if [ ! -z $CONFIG_COMPUTE_HOSTS ] ; then 
		if ping -c 1 $CONFIG_COMPUTE_HOSTS &>/dev/null ; then
			echo ""
			echo "Compute Host is reachable."
		else
			echo ""
			echo "Compute Host is unreachable. exiting !!"
			exit 1
		fi
	fi

	if [ ! -z $CONFIG_NETWORK_HOSTS ] ; then 
		if ping -c 1 $CONFIG_NETWORK_HOSTS &>/dev/null ; then 
			echo ""
			echo "Network Host is reachable"
		else
			echo ""
			echo "Network Host is unreachable. exiting !!"
			exit 1
		fi
	fi

	##Check if modules are available on A
	if lsmod | grep "ip_tables" &> /dev/null ; then
		echo ""
		echo "ip_tables is loaded!"
	else
		echo ""
		echo "ip_tables is not loaded!"
		echo "Installing ip_tables"
		yum remove iptables-services -y >/dev/null 2>&1 
		yum install iptables-services -y >/dev/null 2>&1
	fi

	## Enable IP Forwarding
	/sbin/sysctl -w net.ipv4.ip_forward=1

	echo ""
	echo "Enabling NATTING using iptables."
	# Enable ip forward setting (Try to share network, fail)
	iptables -A FORWARD -i eth0 -o eth1 -m state --state ESTABLISHED,RELATED -j ACCEPT
	iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
	iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -o em2 -j MASQUERADE
	iptables-save > /etc/sysconfig/iptables
	service iptables restart

	echo ""
	echo "Disabling selinux."
	sed -i 's/=enforcing/=disabled/g' /etc/sysconfig/selinux

	# Enable ssh open at all node
	iptables -I INPUT -i eth0 -p tcp --dport 22 -j ACCEPT
}

network_health_checkup
