#!/bin/bash

firewall-cmd --permanent --remove-service='ssh'
firewall-cmd --permanent --add-service='ssh-roger-skyline-1'
firewall-cmd --reload

mv -v /etc/crontab.backup /etc/crontab
