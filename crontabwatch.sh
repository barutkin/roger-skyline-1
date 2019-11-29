#!/bin/bash

# while inotifywait /etc/crontab; do
	if [[ `md5sum /etc/crontab | awk '{print $1}'` != `md5sum /etc/crontab.last | awk '{print $1}'` ]]; then
		echo -e "Subject: `hostname`'s crontab has been changed\n`diff -u /etc/crontab.last /etc/crontab`" | \
			sendmail root
		cp -fv /etc/crontab /etc/crontab.last
	fi
# done
