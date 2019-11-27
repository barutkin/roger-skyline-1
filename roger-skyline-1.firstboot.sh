#!/bin/bash

sleep 12
firewall-cmd --permanent --remove-service='ssh'
firewall-cmd --permanent --remove-service='dhcpv6-client'
firewall-cmd --permanent --add-service='ssh-roger-skyline-1'
firewall-cmd --permanent --add-service='http'
firewall-cmd --permanent --add-service='https'
firewall-cmd --permanent --add-service='kibana'
firewall-cmd --reload
filebeat modules enable suricata apache system
filebeat setup -e

mv -v /etc/crontab.backup /etc/crontab
