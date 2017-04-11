
# packstack installation

# set language configuration
sed -i 's/LANG=en_US.utf-8/#LANG=en_US.utf-8/g' /etc/environment
sed -i 's/LC_ALL=en_US.utf-8/#LC_ALL=en_US.utf-8/g' /etc/environment
echo "LANG=en_US.utf-8" >> /etc/environment
echo "LC_ALL=en_US.utf-8" >> /etc/environment

# install packstack
# change the file name
sudo yum install -y centos-release-openstack-newton
sudo yum update -y
sudo yum install -y openstack-packstack
sudo packstack --answer-file=FILE
