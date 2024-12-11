#!/bin/bash
    echo "Create Network"
    {
    echo "auto vmbr1012" >> "/etc/network/interfaces"
    echo "iface vmbr1012 inet manual" >> "/etc/network/interfaces"
    echo "	bridge-ports none" >> "/etc/network/interfaces"
    echo "	bridge-stp off" >> "/etc/network/interfaces"
    echo "	bridge-fd 0" >> "/etc/network/interfaces" 
    echo >> "/etc/network/interfaces"
    } &>/dev/null
    systemctl restart networking
    echo -e "\033[32m DONE \033[0m" 
    echo "Create VM"
    {
    qm clone 100 1014 --name "ecorouter"
    qm clone 101 1015 --name AltSrv
    qm set 1014 --net0 vmxnet3=1C:87:76:40:00:00,bridge=vmbr9999 --net2 vmxnet3=1C:87:76:40:00:01,bridge=vmbr0 --net2 vmxnet3=1C:87:76:40:00:02,bridge=vmbr1012 --tags="net3 mdk01.02"
    qm set 1015 --net0  vmxnet3,bridge=vmbr1012 --tags="net3 mdk01.02"
    } &> /dev/null
    echo -e "\033[32m DONE \033[0m" 
    echo "Create User"
    {
    pveum group add net
    pveum useradd net3@pve --password P@ssw0rd --enable 1 --groups net
    pveum acl modify /vms/1012 --roles PVEVMUser --users net3@pve
    pveum acl modify /vms/1013 --roles PVEVMUser --users net3@pve
    } &>/dev/null
    echo -e "\033[32m DONE \033[0m\n\n"
    echo -e "\033[34m To login use:\033[0m\n\033[32mLogin:\033[31mnet3\n\033[32mPassword:\033[31mP@ssw0rd\033[0m"