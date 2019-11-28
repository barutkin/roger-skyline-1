#!/bin/bash

cp -fv /etc/crontab /etc/crontab.last
while inotifywait /etc/crontab; do
	if [[ `md5sum /etc/crontab` != `md5sum /etc/crontab.last` ]]; then
		echo -e "Subject: `hostname`'s crontab has been changed\n`diff -u /etc/crontab.last /etc/crontab`" | \
			sendmail root
		cp -fv /etc/crontab /etc/crontab.last
	fi
done
