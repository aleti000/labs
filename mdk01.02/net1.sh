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
    qm set 1010 --net0 vmxnet3=1C:87:76:40:00:00,bridge=vmbr9999 --net1 vmxnet3=1C:87:76:40:00:01,bridge=vmbr0 --net2 vmxnet3=1C:87:76:40:00:02,bridge=vmbr1010 --tags="lab1 mdk01.02"
    qm set 1011 --net0  vmxnet3,bridge=vmbr$lab --tags="lab1 eco"
    } &> /dev/null
    echo -e "\033[32m DONE \033[0m" 
    echo "Создание пользователя"
    {
    pveum group add Net
    pveum useradd Net1@pve --password P@ssw0rd --enable 1 --groups Net
    pveum acl modify /vms/1010 --roles PVEVMUser --users Net1@pve
    pveum acl modify /vms/1020 --roles PVEVMUser --users Net1@pve
    } &>/dev/null
    echo -e "\033[32m DONE \033[0m\n\n"
    echo -e "\033[34m Для доступа используйте:\033[0m\n\033[32mЛогин:\033[31mNet1\n\033[32mПароль:\033[31mP@ssw0rd\033[0m"