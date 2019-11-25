#!/bin/bash

firewall-cmd --permanent --remove-service='ssh'
firewall-cmd --permanent --add-service='ssh-roger-skyline-1'
firewall-cmd --reload

cat /etc/crontab | grep -v firstboot > /etc/crontab.tmp
mv /etc/crontab.tmp /etc/crontab
