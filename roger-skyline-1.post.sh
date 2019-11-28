# Environment
echo "LANG=en_US.utf-8" >> /etc/environment
echo "LC_ALL=en_US.utf-8" >> /etc/environment

# VGA Resolution
cp -v /etc/default/grub /etc/default/grub.backup
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=1/' /etc/default/grub
sed -i 's/GRUB_CMDLINE_LINUX=\"/GRUB_CMDLINE_LINUX=\"vga=795 /' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg

# SSH
cp -v /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
sed -i 's/#Port 22/Port 42122/' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
semanage port --add --type ssh_port_t --proto tcp 42122
cp /usr/lib/firewalld/services/ssh.xml /etc/firewalld/services/ssh-roger-skyline-1.xml
sed -i 's/port=\"22\"/port=\"42122\"/' /etc/firewalld/services/ssh-roger-skyline-1.xml
mkdir -v -p /home/rjeraldi/.ssh
curl -o /home/rjeraldi/.ssh/authorized_keys https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/authorized_keys
chown rjeraldi:rjeraldi -R /home/rjeraldi/.ssh
chmod 700 /home/rjeraldi/.ssh
chmod 600 /home/rjeraldi/.ssh/id_rsa.pub

# HTTPD
curl -o /etc/pki/tls/private/rjeraldi-roger-skyline-1.key https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/rjeraldi-roger-skyline-1.key
chmod 600 /etc/pki/tls/private/rjeraldi-roger-skyline-1.key
curl -o /etc/pki/tls/certs/rjeraldi-roger-skyline-1.crt https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/rjeraldi-roger-skyline-1.crt
chmod 600 /etc/pki/tls/certs/rjeraldi-roger-skyline-1.crt
cp -v /etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/ssl.conf.backup
sed -i 's/SSLCertificateFile \/etc\/pki\/tls\/certs\/localhost.crt/SSLCertificateFile \/etc\/pki\/tls\/certs\/rjeraldi-roger-skyline-1.crt/' /etc/httpd/conf.d/ssl.conf
sed -i 's/SSLCertificateKeyFile \/etc\/pki\/tls\/private\/localhost.key/SSLCertificateKeyFile \/etc\/pki\/tls\/private\/rjeraldi-roger-skyline-1.key/' /etc/httpd/conf.d/ssl.conf
curl -o /etc/httpd/modsecurity.d/modsec.user.conf https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/modsec.user.conf
curl -o /etc/httpd/modsecurity.d/activated_rules/408.conf https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/408.conf
curl -O https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/html.tar.gz
tar -xf html.tar.gz
mv -v html/* /var/www/html/
curl -O https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/mod_evasive-test.pl
systemctl enable httpd

# Suricata
yum --enablerepo=epel-testing install -y suricata
cp -v /etc/sysconfig/suricata /etc/sysconfig/suricata.backup
sed -i 's/OPTIONS=\"-i eth0/OPTIONS=\"-q 0/' /etc/sysconfig/suricata
cp -i /etc/crontab /etc/crontab.clean
echo "@reboot root /usr/sbin/iptables -I INPUT -j NFQUEUE" >> /etc/crontab
echo "@reboot root /usr/sbin/iptables -I OUTPUT -j NFQUEUE" >> /etc/crontab
mv -v /etc/suricata/suricata.yaml /etc/suricata/suricata.yaml.backup
curl -o /etc/suricata/suricata.yaml https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/suricata.yaml
chown suricata:suricata /etc/suricata/suricata.yaml
chmod 640 /etc/suricata/suricata.yaml
curl -O https://rules.emergingthreats.net/open/suricata-`suricata -V | awk -F'This is Suricata version ' '{print $2}' | awk '{print $1}'`/emerging.rules.tar.gz
tar -xf emerging.rules.tar.gz
cp rules/emerging-scan.rules /var/lib/suricata/rules/emerging-scan-drop.rules
sed -i 's/^alert /drop /' /var/lib/suricata/rules/emerging-scan-drop.rules
systemctl enable suricata

# ELK
curl -o /etc/yum.repos.d/elastico.repo https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/elastico.repo
cp -v /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.backup
sed -i 's/#network.host: 192.168.0.1/network.host: localhost/' /etc/elasticsearch/elasticsearch.yml
cp -v /etc/kibana/kibana.yml /etc/kibana/kibana.yml.backup
sed -i 's/#server.port: 5601/server.port: 5601/' /etc/kibana/kibana.yml
sed -i 's/#server.host: \"localhost\"/server.host: 0.0.0.0/' /etc/kibana/kibana.yml
sed -i 's/#server.name: \"your-hostname\"/server.name: \"rjeraldi-roger-skyline-1\"/' /etc/kibana/kibana.yml
systemctl enable elasticsearch
systemctl enable kibana
systemctl enable filebeat

# Update script
curl -O https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/update.sh
echo "@reboot root /bin/bash /root/update.sh" >> /etc/crontab
echo "0 4 * * sun root /bin/bash /root/update.sh" >> /etc/crontab
cp -v /etc/aliases /etc/aliases.backup
echo "root:           barutkin@gmail.com" >> /etc/aliases
echo "@reboot root sleep 30 && cp -fv /etc/crontab /etc/crontab.last && while inotifywait -e close_write /etc/crontab; do echo -e \"Subject: \`hostname | awk -F\'.\' \'{print \$1}\'\`\'s crontab has been changed\n\`diff -u /etc/crontab.last /etc/crontab\`\" | sendmail root; cp -fv /etc/crontab /etc/crontab.last; done" >> /etc/crontab

# First boot script
curl -o /root/roger-skyline-1.firstboot.sh https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/roger-skyline-1.firstboot.sh
chmod +x /root/roger-skyline-1.firstboot.sh
cp -i /etc/crontab /etc/crontab.backup
echo "@reboot root /bin/bash /root/roger-skyline-1.firstboot.sh > /root/roger-skyline-1.firstboot.log" >> /etc/crontab
