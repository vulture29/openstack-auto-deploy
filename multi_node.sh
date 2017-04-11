#!/bin/bash

export PATH=$PATH:/sbin/:/usr/bin/:/bin/

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 2
fi

##clean up the environment
for x in $(virsh list --all | grep instance- | awk '{print $2}') ; do
    virsh destroy $x ;
    virsh undefine $x ;
done ;

yum remove -y nrpe "*nagios*" puppet "*ntp*" "*openstack*" \
"*nova*" "*keystone*" "*glance*" "*cinder*" "*swift*" \
mysql mysql-server httpd "*memcache*" scsi-target-utils \
iscsi-initiator-utils perl-DBI perl-DBD-MySQL ;

rm -rf /etc/nagios /etc/yum.repos.d/packstack_* /root/.my.cnf \
/var/lib/mysql/ /var/lib/glance /var/lib/nova /etc/nova /etc/swift \
/srv/node/device*/* /var/lib/cinder/ /etc/rsync.d/frag* \
/var/cache/swift /var/log/keystone /var/log/cinder/ /var/log/nova/ \
/var/log/httpd /var/log/glance/ /var/log/nagios/ /var/log/quantum/ ;

umount /srv/node/device* >/dev/null 2>&1;
killall -9 dnsmasq tgtd httpd >/dev/null 2>&1;

vgremove -f cinder-volumes >dev/null 2>&1;
losetup -a | sed -e 's/:.*//g' | xargs losetup -d >/dev/null 2>&1; 
find /etc/pki/tls -name "ssl_ps*" | xargs rm -rf ;
for x in $(df | grep "/lib/" | sed -e 's/.* //g') ; do
    umount $x >/dev/null 2>&1;
done

## Reading from answers.txt file
if [ -f "/root/newton-answer.txt" ]
then
  echo "File Exists\n"
  source /root/newton-answer.txt
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
  echo "ip_tables is not loaded!"
  echo "Installing ip_tables"
  yum remove iptables-services -y >/dev/null 2>&1 
  yum install iptables-services -y
fi

## Making changes on Controller
if lsmod | grep "firewalld" &> /dev/null ; then
  echo "firewalld is loaded!"
  echo "Disabling and stopping it"
  systemctl disable firewalld
  systemctl stop firewalld
  systemctl disable NetworkManager
  systemctl stop NetworkManager
else
   echo "Firewalld is not loaded"
fi

## Enable IP Forwarding
`/sbin/sysctl -w net.ipv4.ip_forward=1 `


# Enable ip forward setting (Try to share network, fail)

`iptables -A FORWARD -i eth0 -o eth1 -m state --state ESTABLISHED,RELATED -j ACCEPT ` 
`iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT `
`iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -o em2 -j MASQUERADE` 
`iptables-save > /etc/sysconfig/iptables `
`service iptables restart `

` sed -i 's/=enforcing/=disabled/g' /etc/sysconfig/selinux `

# Enable ssh open at all node
`iptables -I INPUT -i eth0 -p tcp --dport 22 -j ACCEPT `

# packstack installation
# set language configuration
sed -i 's/LANG=en_US.utf-8/#LANG=en_US.utf-8/g' /etc/environment
sed -i 's/LC_ALL=en_US.utf-8/#LC_ALL=en_US.utf-8/g' /etc/environment
echo "LANG=en_US.utf-8" >> /etc/environment
echo "LC_ALL=en_US.utf-8" >> /etc/environment

# install packstack from the answer file
# change the file name
yum install -y centos-release-openstack-newton
yum update -y
yum install -y openstack-packstack
packstack --answer-file=FILE
