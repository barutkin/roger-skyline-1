#!/bin/bash

VBoxManage createvm --name "roger-skyline-1" -ostype RedHat_64 --register
VBoxManage createmedium disk --filename "$HOME/VirtualBox VMs/roger-skyline-1/roger-skyline-1.vdi" --sizebyte 8000000000
VBoxManage natnetwork add --netname roger-skyline-1.net --network "192.168.0.0/24" --enable --dhcp off --ipv6 off --port-forward-4 "ssh:tcp:[]:42122:[192.168.0.4]:42122" --port-forward-4 "http:tcp:[]:42180:[192.168.0.4]:80" --port-forward-4 "https:tcp:[]:42143:[192.168.0.4]:443" --port-forward-4 "kibana:tcp:[]:42156:[192.168.0.4]:5601"
VBoxManage natnetwork start --netname roger-skyline-1.net
VBoxManage modifyvm roger-skyline-1 --cpus 2 --memory 2560 --vram=16
VBoxManage modifyvm roger-skyline-1 --acpi on --ioapic on
VBoxManage modifyvm roger-skyline-1 --hwvirtex on --nestedpaging on --largepages on
VBoxManage modifyvm roger-skyline-1 --accelerate3d off --accelerate2dvideo off
VBoxManage modifyvm roger-skyline-1 --nic1 natnetwork --nat-network1 roger-skyline-1.net
VBoxManage modifyvm roger-skyline-1 --boot1 disk --boot2 DVD --boot3 none --boot4 none
VBoxManage storagectl roger-skyline-1 --name "SATA Controller" --add sata --controller IntelAHCI
VBoxManage storageattach roger-skyline-1 --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$HOME/VirtualBox VMs/roger-skyline-1/roger-skyline-1.vdi"
VBoxManage storagectl roger-skyline-1 --name "IDE Controller" --add ide
VBoxManage storageattach roger-skyline-1 --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "$HOME/goinfre/CentOS-7-x86_64-NetInstall-1908.iso"
VBoxManage storageattach roger-skyline-1 --storagectl "SATA Controller" --port 1 --device 0 --type hdd --medium ./OEMDRV.vmdk
VBoxManage startvm roger-skyline-1
