#!/bin/bash
    echo "Подготовка сети"
    {
    echo "auto vmbr1010" >> "/etc/network/interfaces"
    echo "iface vmbr1010 inet manual" >> "/etc/network/interfaces"
    echo "	bridge-ports none" >> "/etc/network/interfaces"
    echo "	bridge-stp off" >> "/etc/network/interfaces"
    echo "	bridge-fd 0" >> "/etc/network/interfaces" 
    echo >> "/etc/network/interfaces"
    } &>/dev/null
    systemctl restart networking
    echo -e "\033[32m DONE \033[0m" 
    echo "Настройка виртуальных машин"
    {
    qm clone 100 1010 --name "ecorouter"
    qm clone 101 1011 --name AltSrv
    qm set 1010 --net0 vmxnet3=1C:87:76:40:00:00,bridge=vmbr9999 --net1 vmxnet3=1C:87:76:40:00:01,bridge=vmbr0 --net2 vmxnet3=1C:87:76:40:00:02,bridge=vmbr1010 --tags="net1 mdk01.02"
    qm set 1011 --net0  vmxnet3,bridge=vmbr1010 --tags="net1 mdk01.02"
    } &> /dev/null
    echo -e "\033[32m DONE \033[0m" 
    echo "Создание пользователя"
    {
    pveum group add net
    pveum useradd net1@pve --password P@ssw0rd --enable 1 --groups net
    pveum acl modify /vms/1010 --roles PVEVMUser --users net1@pve
    pveum acl modify /vms/1011 --roles PVEVMUser --users net1@pve
    } &>/dev/null
    echo -e "\033[32m DONE \033[0m\n\n"
    echo -e "\033[34m Для доступа используйте:\033[0m\n\033[32mЛогин:\033[31mnet1\n\033[32mПароль:\033[31mP@ssw0rd\033[0m"