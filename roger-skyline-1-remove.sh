#!/bin/bash

VBoxManage controlvm roger-skyline-1 poweroff
sleep 2
VBoxManage unregistervm roger-skyline-1
VBoxManage closemedium disk /Users/rjeraldi/VirtualBox\ VMs/roger-skyline-1/roger-skyline-1.vdi --delete
VBoxManage natnetwork stop --netname roger-skyline-1.net
VBoxManage natnetwork remove --netname roger-skyline-1.net
VBoxManage dhcpserver remove --netname roger-skyline-1.net
rm -rf /Users/rjeraldi/VirtualBox\ VMs/roger-skyline-1/
