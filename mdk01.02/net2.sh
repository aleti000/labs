#!/bin/bash
    echo "Create Network"
    {
    echo "auto vmbr1011" >> "/etc/network/interfaces"
    echo "iface vmbr1011 inet manual" >> "/etc/network/interfaces"
    echo "	bridge-ports none" >> "/etc/network/interfaces"
    echo "	bridge-stp off" >> "/etc/network/interfaces"
    echo "	bridge-fd 0" >> "/etc/network/interfaces" 
    echo >> "/etc/network/interfaces"
    } &>/dev/null
    systemctl restart networking
    echo -e "\033[32m DONE \033[0m" 
    echo "Create VM"
    {
    qm clone 100 1012 --name "ecorouter"
    qm clone 101 1013 --name AltSrv
    qm set 1012 --net0 vmxnet3=1C:87:76:40:00:00,bridge=vmbr9999 --net1 vmxnet3=1C:87:76:40:00:01,bridge=vmbr0 --net2 vmxnet3=1C:87:76:40:00:02,bridge=vmbr1011 --net3 vmxnet3=1C:87:76:40:00:03,bridge=vmbr0  --tags="mdk01.02 net2"
    qm set 1013 --net0  vmxnet3,bridge=vmbr1011 --tags="mdk01.02 net2"
    } &> /dev/null
    echo -e "\033[32m DONE \033[0m" 
    echo "Create user"
    {
    pveum group add net
    pveum useradd net2@pve --password P@ssw0rd --enable 1 --groups net
    pveum acl modify /vms/1012 --roles PVEVMUser --users net2@pve
    pveum acl modify /vms/1013 --roles PVEVMUser --users net2@pve
    } &>/dev/null
    echo -e "\033[32m DONE \033[0m\n\n"
    echo -e "\033[34m To login use:\033[0m\n\033[32mLogin:\033[31mnet2\n\033[32mPassword:\033[31mP@ssw0rd\033[0m"