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
echo "sed -i 's/#discovery.seed_hosts: \[\"host1\", \"host2\"\]/discovery.seed_hosts: \[\"127.0.0.1\"\]/' /etc/elasticsearch/elasticsearch.yml"
sed -i 's/#discovery.seed_hosts: \[\"host1\", \"host2\"\]/discovery.seed_hosts: \[\"127.0.0.1\"\]/' /etc/elasticsearch/elasticsearch.yml
echo "systemctl restart elasticsearch"
systemctl restart elasticsearch
echo "newaliases"
newaliases

mv -v /etc/crontab.backup /etc/crontab
