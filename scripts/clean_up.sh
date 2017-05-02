#!/bin/bash

function clean_up()
{
        echo ""
        echo "Destroying VM's and undefining them."
        ##clean up the environment
        for x in $(virsh list --all | grep instance- | awk '{print $2}') ; do
                virsh destroy $x ;
                virsh undefine $x ;
        done ;

        echo ""
        echo "Removing openstack RPM's."
        yum remove -y nrpe "*nagios*" packstack puppet "*ntp*" "*openstack*" \
        "*nova*" "*keystone*" "*glance*" "*cinder*" "*swift*" "*neutron*" \
        mysql mysql-server httpd "*memcache*" scsi-target-utils \
        iscsi-initiator-utils perl-DBI perl-DBD-MySQL >/dev/null 2>&1;

        rm -rf /etc/nagios /etc/yum.repos.d/packstack_* /root/.my.cnf \
        /var/lib/mysql/ /var/lib/glance /var/lib/nova /etc/nova /etc/swift \
        /srv/node/device*/* /var/lib/cinder/ /etc/rsync.d/frag* \
        /var/cache/swift /var/log/keystone /var/log/cinder/ /var/log/nova/ \
        /var/log/httpd /var/log/glance/ /var/log/nagios/ /var/log/quantum/ ;

        umount /srv/node/device* >/dev/null 2>&1;
        killall -9 dnsmasq tgtd httpd >/dev/null 2>&1;

        echo ""
        echo "Removing cinder volumes."
        vgremove -f cinder-volumes >/dev/null 2>&1;
        losetup -a | sed -e 's/:.*//g' | xargs losetup -d >/dev/null 2>&1;
        find /etc/pki/tls -name "ssl_ps*" | xargs rm -rf ;
        for x in $(df | grep "/lib/" | sed -e 's/.* //g') ; do
                umount $x >/dev/null 2>&1;
        done
        
        echo ""
        echo "Removing config file."
        rm -rf config/rc.conf
}

clean_up
