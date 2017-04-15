#!/bin/bash

function precheck_before_install()
{
        #confirm if hardware virtualization
        if ! egrep -c '(vmx|svm)' /proc/cpuinfo >/dev/null 2>&1 ; then
                echo ""
                echo "Hardware Virtualization is not enabled."
                exit 1
        fi

        #confirm if the user install kvm
        if ! lsmod | grep -q kvm ; then
                echo ""
                echo "KVM kernel Module is missing."

                echo ""
                echo "Do you want me to insert the module ?.[y/n]"
                read answer
                if [ $answer == "y" ] || [ $answer == "Y" ] ; then
                        /sbin/modprobe kvm
                        if [ $? -ne 0 ] ; then
                                echo ""
                                echo "KVM kernel Module Insert Failed."
                                exit 1
                        fi
                fi

        fi

        if ! rpm -q lsof >/dev/null ; then
                echo ""
                echo "Installing lsof RPM."
                yum install lsof >/dev/null 1>&2
        fi

        #confirm the keystone
        if lsof -i :5000 >/dev/null ; then
                echo ""
                echo "Port 5000 is not free. It is a prerequisite for keystone service."
                echo ""
                echo "Do you want me to free the port ?.[y/n]"
                read answer
                if [  $answer == "y" ] || [ $answer == "Y" ] ; then
                        lsof -i :5000 |grep -v "PID"|awk '{print "kill -9",$2}'|sh;
                else
                        exit 1;
                fi
        fi

        if lsof -i :35357 >/dev/null ; then
                echo ""
                echo "Port 35357 is not free. It is a prerequisite."
                echo ""
                echo "Do you want me to free the port ?.[y/n]"
                read answer
                if [  $answer == "y" ] || [ $answer == "Y" ] ; then
                        lsof -i :35357 |grep -v "PID"|awk '{print "kill -9",$2}'|sh;
                else
                        exit 1;
                fi
        fi

        if lsof -i :11211 >/dev/null ; then
                echo ""
                echo "Port 11211 is not free. It is a prerequisite."
                echo ""
                echo "Do you want me to free the port ?.[y/n]"
                read answer
                if [  $answer == "y" ] || [ $answer == "Y" ] ; then
                        lsof -i :11211 |grep -v "PID"|awk '{print "kill -9",$2}'|sh;
                else
                        exit 1;
                fi
        fi

        #horizon

        #Neutron
        if ! rpm -q ebtables >/dev/null ; then
                echo ""
                echo "Installing ebtables RPM."
                yum install ebtables >/dev/null 1>&2
        fi

        if ! rpm -q ipset >/dev/null ; then
                echo ""
                echo "Installing ipset RPM."
                yum install ipset >/dev/null 1>&2
        fi

        if lsof -i :9696 >/dev/null ; then
                echo ""
                echo "Port 9696 is not free. It is a prerequisite for Neutron Service."
                echo ""
                echo "Do you want me to free the port ?.[y/n]"
                read answer
                if [  $answer == "y" ] || [ $answer == "Y" ] ; then
                        lsof -i :9696 |grep -v "PID"|awk '{print "kill -9",$2}'|sh;
                else
                        exit 1;
                fi
        fi

        #Glance
        if lsof -i :9292 >/dev/null ; then
                echo ""
                echo "Port 9292 is not free. It is a prerequisite for Glance Service."
                echo ""
                echo "Do you want me to free the port ?.[y/n]"
                read answer
                if [  $answer == "y" ] || [ $answer == "Y" ] ; then
                        lsof -i :9292 |grep -v "PID"|awk '{print "kill -9",$2}'|sh;
                else
                        exit 1;
                fi
        fi

        #Nova
        if lsof -i :8774 >/dev/null ; then
                echo ""
                echo "Port 8774 is not free. It is a prerequisite for Nova Service."
                echo ""
                echo "Do you want me to free the port ?.[y/n]"
                read answer
                if [  $answer == "y" ] || [ $answer == "Y" ] ; then
                        lsof -i :8774 |grep -v "PID"|awk '{print "kill -9",$2}'|sh;
                else
                        exit 1;
                fi
        fi

}

precheck_before_install
