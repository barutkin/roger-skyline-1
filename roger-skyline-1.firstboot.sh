#!/bin/bash

firewall-cmd --permanent --remove-service='ssh'
firewall-cmd --permanent --add-service='ssh-roger-skyline-1'
firewall-cmd --permanent --add-service='http'
firewall-cmd --permanent --add-service='https'
firewall-cmd --reload
filebeat modules enable suricata apache system
filebeat modules list
filebeat setup -e

mv -v /etc/crontab.backup /etc/crontab
