#!/bin/bash

echo ""
echo "Installing the KVM packages."
yum install qemu-kvm libvirt-bin virtinst bridge-utils virt-viewer -y >/dev/null 2>&1

if [ $? -eq 0 ] ; then 
	echo ""
	echo "Installed successfully"
else
	echo ""
	echo "installation failed"
fi

echo ""
echo "Configuring your compute VM"

echo ""
echo "Enter compute vm name"
read name

echo ""
echo "Enter value vcpus (recommended minimum 1):"
read vcpus

echo ""
echo "Enter value for RAM (recommended minimum 2 GB):"
read ram

echo ""
echo "Enter value for disk size (hint : 10):"
read diskSize

echo ""
echo "Enter network name (hint: run the command 'virsh net-list'. For ex: default)"
read networkName

echo ""
echo "Enter bridge name (hint: run the  ifconfig command. For ex: virbr0)"
read bridgeName

echo ""
echo "Enter Repository Location:(http://mirror.centos.org/centos/6.6/os/x86_64/)"
read location

echo ""
echo "Installing VM"

virt-install \
--virt-type=kvm \
--name $name \
--ram $ram \
--vcpus=$vcpus \
--os-variant=rhel7 \
--virt-type=kvm \
--hvm \
--nographics \
--network network=$networkName,model=virtio \
--location=http://vault.centos.org/7.3.1611/os/Source/ \
--disk path=/var/lib/libvirt/images/centos7_new.img,size=10,bus=virtio \
--initrd-inject=ks.cfg \
--extra-args='ks=file:/ks.cfg console=ttyS0'