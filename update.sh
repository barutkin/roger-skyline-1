#!/bin/bash

logFile="/var/log/update_script.log"
echo "======== `date` ========" >> $logFile
echo "yum updateinfo:" >> $logFile
yum updateinfo 2>&1 1>> $logFile
echo "yum update:" >> $logFile
yum update 2>&1 1>> $logFile
