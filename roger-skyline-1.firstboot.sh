#!/bin/bash

sleep 10
echo "firewall-cmd --permanent --remove-service='ssh'"
firewall-cmd --permanent --remove-service='ssh'
echo "firewall-cmd --permanent --remove-service='dhcpv6-client'"
firewall-cmd --permanent --remove-service='dhcpv6-client'
echo "firewall-cmd --permanent --add-service='ssh-roger-skyline-1'"
firewall-cmd --permanent --add-service='ssh-roger-skyline-1'
echo "firewall-cmd --permanent --add-service='http'"
firewall-cmd --permanent --add-service='http'
echo "firewall-cmd --permanent --add-service='https'"
firewall-cmd --permanent --add-service='https'
echo "firewall-cmd --permanent --add-service='kibana'"
firewall-cmd --permanent --add-service='kibana'
echo "firewall-cmd --reload"
firewall-cmd --reload
echo "sleep 90"
sleep 90
echo "filebeat modules enable suricata apache system"
filebeat modules enable suricata apache system
echo "sleep 30"
sleep 30
echo "filebeat setup -e"
filebeat setup -e
echo "newaliases"
newaliases

mv -v /etc/crontab.backup /etc/crontab
