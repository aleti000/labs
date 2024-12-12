#!/bin/bash
    echo "Create Network"
    {
    echo "auto vmbr2021" >> "/etc/network/interfaces"
    echo "iface vmbr2021 inet manual" >> "/etc/network/interfaces"
    echo "	bridge-ports none" >> "/etc/network/interfaces"
    echo "	bridge-stp off" >> "/etc/network/interfaces"
    echo "	bridge-fd 0" >> "/etc/network/interfaces" 
    echo >> "/etc/network/interfaces"
    } &>/dev/null
    systemctl restart networking
    echo -e "\033[32m DONE \033[0m" 
    echo "Create VM"
    {
    qm clone 101 2021 --name AltSrv
    qm clone 102 2022 --name AltWks
    qm set 2021 --net0  vmxnet3,bridge=vmbr0 --net1  vmxnet3,bridge=vmbr2021 --tags="mdk01.02 adm2"
    qm set 2022 --net0  vmxnet3,bridge=vmbr2021 --tags="mdk01.02 adm2"
    } &> /dev/null
    echo -e "\033[32m DONE \033[0m" 
    echo "Create User"
    {
    pveum group add adm
    pveum useradd adm2@pve --password P@ssw0rd --enable 1 --groups adm
    pveum acl modify /vms/2021 --roles PVEVMUser --users adm2@pve
    pveum acl modify /vms/2022 --roles PVEVMUser --users adm2@pve
    } &>/dev/null
    echo -e "\033[32m DONE \033[0m\n\n"
    echo -e "\033[34m To login use:\033[0m\n\033[32mLogin:\033[31madm2\n\033[32mPassword:\033[31mP@ssw0rd\033[0m"