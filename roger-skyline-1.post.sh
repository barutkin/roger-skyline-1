# Environment
echo "LANG=en_US.utf-8 >> /etc/environment"
echo "LANG=en_US.utf-8" >> /etc/environment
echo "LC_ALL=en_US.utf-8 >> /etc/environment"
echo "LC_ALL=en_US.utf-8" >> /etc/environment

# VGA Resolution
cp -v /etc/default/grub /etc/default/grub.backup
echo "sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=1/' /etc/default/grub"
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=1/' /etc/default/grub
echo "sed -i 's/GRUB_CMDLINE_LINUX=\"/GRUB_CMDLINE_LINUX=\"vga=795 /' /etc/default/grub"
sed -i 's/GRUB_CMDLINE_LINUX=\"/GRUB_CMDLINE_LINUX=\"vga=795 /' /etc/default/grub
echo "grub2-mkconfig -o /boot/grub2/grub.cfg"
grub2-mkconfig -o /boot/grub2/grub.cfg

# SSH
cp -v /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
echo "sed -i 's/#Port 22/Port 42122/' /etc/ssh/sshd_config"
sed -i 's/#Port 22/Port 42122/' /etc/ssh/sshd_config
echo "sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config"
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
echo "sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config"
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
echo "semanage port --add --type ssh_port_t --proto tcp 42122"
semanage port --add --type ssh_port_t --proto tcp 42122
cp -v /usr/lib/firewalld/services/ssh.xml /etc/firewalld/services/ssh-roger-skyline-1.xml
echo "sed -i 's/port=\"22\"/port=\"42122\"/' /etc/firewalld/services/ssh-roger-skyline-1.xml"
sed -i 's/port=\"22\"/port=\"42122\"/' /etc/firewalld/services/ssh-roger-skyline-1.xml
mkdir -v -p /home/rjeraldi/.ssh
echo "curl -o /home/rjeraldi/.ssh/authorized_keys https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/authorized_keys"
curl -o /home/rjeraldi/.ssh/authorized_keys https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/authorized_keys
echo "chown rjeraldi:rjeraldi -R /home/rjeraldi/.ssh"
chown rjeraldi:rjeraldi -R /home/rjeraldi/.ssh
chmod 700 -v /home/rjeraldi/.ssh
chmod 600 -v /home/rjeraldi/.ssh/id_rsa.pub

# HTTPD
echo "curl -o /etc/pki/tls/private/rjeraldi-roger-skyline-1.key https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/rjeraldi-roger-skyline-1.key"
curl -o /etc/pki/tls/private/rjeraldi-roger-skyline-1.key https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/rjeraldi-roger-skyline-1.key
chmod 600 -v /etc/pki/tls/private/rjeraldi-roger-skyline-1.key
echo "curl -o /etc/pki/tls/certs/rjeraldi-roger-skyline-1.crt https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/rjeraldi-roger-skyline-1.crt"
curl -o /etc/pki/tls/certs/rjeraldi-roger-skyline-1.crt https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/rjeraldi-roger-skyline-1.crt
chmod 600 -v /etc/pki/tls/certs/rjeraldi-roger-skyline-1.crt
echo "cp -v /etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/ssl.conf.backup"
cp -v /etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/ssl.conf.backup
echo "sed -i 's/SSLCertificateFile \/etc\/pki\/tls\/certs\/localhost.crt/SSLCertificateFile \/etc\/pki\/tls\/certs\/rjeraldi-roger-skyline-1.crt/' /etc/httpd/conf.d/ssl.conf"
sed -i 's/SSLCertificateFile \/etc\/pki\/tls\/certs\/localhost.crt/SSLCertificateFile \/etc\/pki\/tls\/certs\/rjeraldi-roger-skyline-1.crt/' /etc/httpd/conf.d/ssl.conf
echo "sed -i 's/SSLCertificateKeyFile \/etc\/pki\/tls\/private\/localhost.key/SSLCertificateKeyFile \/etc\/pki\/tls\/private\/rjeraldi-roger-skyline-1.key/' /etc/httpd/conf.d/ssl.conf"
sed -i 's/SSLCertificateKeyFile \/etc\/pki\/tls\/private\/localhost.key/SSLCertificateKeyFile \/etc\/pki\/tls\/private\/rjeraldi-roger-skyline-1.key/' /etc/httpd/conf.d/ssl.conf
echo "curl -o /etc/httpd/modsecurity.d/modsec.user.conf https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/modsec.user.conf"
curl -o /etc/httpd/modsecurity.d/modsec.user.conf https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/modsec.user.conf
echo "curl -o /etc/httpd/modsecurity.d/activated_rules/408.conf https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/408.conf"
curl -o /etc/httpd/modsecurity.d/activated_rules/408.conf https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/408.conf
echo "curl -O https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/html.tar.gz"
curl -O https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/html.tar.gz
echo "tar -xf html.tar.gz"
tar -xf html.tar.gz
mv -v html/* /var/www/html/
echo "curl -O https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/mod_evasive-test.pl"
curl -O https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/mod_evasive-test.pl
echo "systemctl enable httpd"
systemctl enable httpd

# Suricata
echo "yum --enablerepo=epel-testing install -y suricata"
yum --enablerepo=epel-testing install -y suricata
cp -v /etc/sysconfig/suricata /etc/sysconfig/suricata.backup
echo "sed -i 's/OPTIONS=\"-i eth0/OPTIONS=\"-q 0/' /etc/sysconfig/suricata"
sed -i 's/OPTIONS=\"-i eth0/OPTIONS=\"-q 0/' /etc/sysconfig/suricata
cp -v /etc/crontab /etc/crontab.clean
echo "echo @reboot root sleep 60 && /usr/sbin/iptables -I INPUT -j NFQUEUE && /usr/sbin/iptables -I OUTPUT -j NFQUEUE >> /etc/crontab"
echo "@reboot root sleep 60 && /usr/sbin/iptables -I INPUT -j NFQUEUE && /usr/sbin/iptables -I OUTPUT -j NFQUEUE" >> /etc/crontab
mv -v /etc/suricata/suricata.yaml /etc/suricata/suricata.yaml.backup
echo "curl -o /etc/suricata/suricata.yaml https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/suricata.yaml"
curl -o /etc/suricata/suricata.yaml https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/suricata.yaml
echo "chown suricata:suricata /etc/suricata/suricata.yaml"
chown suricata:suricata /etc/suricata/suricata.yaml
chmod 640 -v /etc/suricata/suricata.yaml
echo "curl -O https://rules.emergingthreats.net/open/suricata-`suricata -V | awk -F'This is Suricata version ' '{print $2}' | awk '{print $1}'`/emerging.rules.tar.gz"
curl -O https://rules.emergingthreats.net/open/suricata-`suricata -V | awk -F'This is Suricata version ' '{print $2}' | awk '{print $1}'`/emerging.rules.tar.gz
echo "tar -xf emerging.rules.tar.gz"
tar -xf emerging.rules.tar.gz
mkdir -pv /var/lib/suricata/rules
cp -v rules/emerging-scan.rules /var/lib/suricata/rules/
# cp -v rules/emerging-scan.rules /var/lib/suricata/rules/emerging-scan-drop.rules
# echo "sed -i 's/^alert /drop /' /var/lib/suricata/rules/emerging-scan-drop.rules"
# sed -i 's/^alert /drop /' /var/lib/suricata/rules/emerging-scan-drop.rules
echo "systemctl enable suricata"
systemctl enable suricata

# ELK
echo "curl -o /etc/yum.repos.d/elastico.repo https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/elastico.repo"
curl -o /etc/yum.repos.d/elastico.repo https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/elastico.repo
cp -v /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.backup
echo "sed -i 's/#network.host: 192.168.0.1/network.host: localhost/' /etc/elasticsearch/elasticsearch.yml"
sed -i 's/#network.host: 192.168.0.1/network.host: localhost/' /etc/elasticsearch/elasticsearch.yml
cp -v /etc/kibana/kibana.yml /etc/kibana/kibana.yml.backup
echo "sed -i 's/#server.port: 5601/server.port: 5601/' /etc/kibana/kibana.yml"
sed -i 's/#server.port: 5601/server.port: 5601/' /etc/kibana/kibana.yml
echo "sed -i 's/#server.host: \"localhost\"/server.host: 0.0.0.0/' /etc/kibana/kibana.yml"
sed -i 's/#server.host: \"localhost\"/server.host: 0.0.0.0/' /etc/kibana/kibana.yml
echo "sed -i 's/#server.name: \"your-hostname\"/server.name: \"rjeraldi-roger-skyline-1\"/' /etc/kibana/kibana.yml"
sed -i 's/#server.name: \"your-hostname\"/server.name: \"rjeraldi-roger-skyline-1\"/' /etc/kibana/kibana.yml
echo "systemctl enable elasticsearch"
systemctl enable elasticsearch
echo "systemctl enable kibana"
systemctl enable kibana
echo "curl -o /etc/filebeat/filebeat.yml https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/filebeat.yml"
curl -o /etc/filebeat/filebeat.yml https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/filebeat.yml
chmod 600 -v /etc/filebeat/filebeat.yml
echo "systemctl enable filebeat"
systemctl enable filebeat

# Update script
echo "curl -o /root/update.sh https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/update.sh"
curl -o /root/update.sh https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/update.sh
echo "echo @reboot root sleep 60 && /bin/bash /root/update.sh >> /etc/crontab"
echo "@reboot root sleep 60 && /bin/bash /root/update.sh" >> /etc/crontab
echo "echo 0 4 * * sun root /bin/bash /root/update.sh >> /etc/crontab"
echo "0 4 * * sun root /bin/bash /root/update.sh" >> /etc/crontab
cp -v /etc/aliases /etc/aliases.backup
echo "root:           barutkin@gmail.com >> /etc/aliases"
echo "root:           barutkin@gmail.com" >> /etc/aliases

# Crontabwatch
echo "curl -o /root/crontabwatch.sh https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/crontabwatch.sh"
curl -o /root/crontabwatch.sh https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/crontabwatch.sh
echo "echo @reboot root sleep 120 && /bin/bash /root/crontabwatch.sh >> /etc/crontab"
echo "@reboot root sleep 120 && /bin/bash /root/crontabwatch.sh" >> /etc/crontab

# First boot script
echo "curl -o /root/roger-skyline-1.firstboot.sh https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/roger-skyline-1.firstboot.sh"
curl -o /root/roger-skyline-1.firstboot.sh https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/roger-skyline-1.firstboot.sh
cp -v /etc/crontab /etc/crontab.backup
echo "echo @reboot root /bin/bash /root/roger-skyline-1.firstboot.sh > /root/roger-skyline-1.firstboot.log >> /etc/crontab"
echo "@reboot root /bin/bash /root/roger-skyline-1.firstboot.sh > /root/roger-skyline-1.firstboot.log" >> /etc/crontab
