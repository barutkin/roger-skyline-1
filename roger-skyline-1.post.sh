# Environment
echo "LANG=en_US.utf-8" >> /etc/environment
echo "LC_ALL=en_US.utf-8" >> /etc/environment

# First boot script
curl -o /root/roger-skyline-1.firstboot.sh https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/roger-skyline-1.firstboot.sh
chmod +x /root/roger-skyline-1.firstboot.sh
cp -i /etc/crontab /etc/crontab.backup
echo "@reboot root /bin/bash /root/roger-skyline-1.firstboot.sh" >> /etc/crontab

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
curl -o /etc/httpd/modsecurity.d//activated_rules/408.conf https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/408.conf
curl -O https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/html.tar.gzip
tar -xf html.tar.gzip
mv -v html/* /var/www/html/

# Suricata
yum --enablerepo=epel-testing install -y suricata
