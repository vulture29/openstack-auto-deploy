#!/bin/bash

function network_health_checkup()
{
	## Reading from answers.txt file
	if [ -f "config/answer.txt" ]
	then
		source config/answer.txt
	else
		echo "ERROR -- no file answer.txt"
		exit 1
	fi

	## Check if all the nodes are reachable from controller
	if ping -c 1 $CONFIG_COMPUTE_HOSTS >/dev/null 1>&2 ; then
		echo "$CONFIG_COMPUTE_HOSTS is reachable"
	else
		echo "$CONFIG_COMPUTE_HOSTS is unreachable"
		exit 1
	fi

	if ping -c 1 $CONFIG_NETWORK_HOSTS >/dev/null 1>&2 ; then 
		echo "$CONFIG_NETWORK_HOSTS is reachable"
	else
		echo "$CONFIG_NETWORK_HOSTS is unreachable"
		exit 1
	fi

	##Check if modules are available on A
	if lsmod | grep "ip_tables" &> /dev/null ; then
		echo "ip_tables is loaded!"
	else
		echo ""
		echo "ip_tables is not loaded!"
		echo "Installing ip_tables"
		yum remove iptables-services -y >/dev/null 2>&1 
		yum install iptables-services -y
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
