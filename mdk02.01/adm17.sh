#!/bin/bash
    echo "Create Network"
    {
    echo "auto vmbr2010" >> "/etc/network/interfaces"
    echo "iface vmbr2010 inet manual" >> "/etc/network/interfaces"
    echo "	bridge-ports none" >> "/etc/network/interfaces"
    echo "	bridge-stp off" >> "/etc/network/interfaces"
    echo "	bridge-fd 0" >> "/etc/network/interfaces" 
    echo >> "/etc/network/interfaces"
    } &>/dev/null
    systemctl restart networking
    echo -e "\033[32m DONE \033[0m" 
    echo "Create VM"
    {
    qm clone 101 2010 --name AltSrv
    qm set 2010 --net0  vmxnet3,bridge=vmbr0 --tags="mdk02.01"
    } &> /dev/null
    echo -e "\033[32m DONE \033[0m" 
    echo "Create User"
    {
    pveum group add adm
    pveum useradd adm17@pve --password P@ssw0rd --enable 1 --groups net
    pveum acl modify /vms/2010 --roles PVEVMUser --users adm17@pve
    } &>/dev/null
    echo -e "\033[32m DONE \033[0m\n\n"
    echo -e "\033[34m To login use:\033[0m\n\033[32mLogin:\033[31madm17\n\033[32mPassword:\033[31mP@ssw0rd\033[0m"