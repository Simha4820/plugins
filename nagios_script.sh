#!/bin/bash

yum install nagios-plugins-all nagios-plugins-nrpe nrpe -y
cp /etc/nagios/nrpe.cfg /etc/nagios/nrpe.cfg.bkp
cp nrpe.cfg /etc/nagios/nrpe.cfg
cp check_* /usr/lib64/nagios/plugins/
chmod 0755 /usr/lib64/nagios/plugins/check_*
systemctl restart nrpe
systemctl status nrpe

/usr/lib64/nagios/plugins/check_users -w 3 -c 5
/usr/lib64/nagios/plugins/check_load -w 15,10,5 -c 30,25,20
/usr/lib64/nagios/plugins/check_mem -w 80 -c 90
/usr/lib64/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme0n1p1
/usr/lib64/nagios/plugins/check_procs -w 350 -c 450
/usr/lib64/nagios/plugins/check_swap -w 20% -c 10%
/usr/lib64/nagios/plugins/check_uptime
