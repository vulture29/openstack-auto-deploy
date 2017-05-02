#!/bin/bash

function install_openstack()
{
	echo ""
	echo "--> Updaing kernel. (It might take sometime)"
	yum update -y >/dev/null 2>&1;
	packstack --answer-file=$1
}
