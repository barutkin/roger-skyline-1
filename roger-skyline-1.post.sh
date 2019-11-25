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
curl -o /home/rjeraldi/.ssh/id_rsa.pub https://raw.githubusercontent.com/barutkin/roger-skyline-1/master/id_rsa.pub
chown rjeraldi:rjeraldi -R /home/rjeraldi/.ssh
chmod 700 -R /home/rjeraldi/.ssh
echo "@reboot root /bin/bash /root/roger-skyline-1.firstboot.sh" >> /etc/crontab

# Suricata
yum --enablerepo=epel-testing install -y suricata
