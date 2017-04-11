# clean up

# network configuration
Last login: Mon Apr 10 20:36:07 on ttys001
~$ 
~$ cd shell_script/
shell_script$ ls
H2manush	multi_node.sh
shell_script$ 
shell_script$ 
shell_script$ 
shell_script$ vi multi_node.sh 
shell_script$ vi multi_node.sh 










































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
`yum install iptables-services -y`
fi

## Making changes on Controller
if lsmod | grep "firewalld" &> /dev/null ; then
  echo "firewalld is loaded!"
  echo "Disabling and stopping it"
  `systemctl disable firewalld `
  `systemctl stop firewalld `
  `systemctl disable NetworkManager `
  `systemctl stop NetworkManager `
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
sudo yum install -y centos-release-openstack-newton
sudo yum update -y
sudo yum install -y openstack-packstack
sudo packstack --answer-file=FILE
