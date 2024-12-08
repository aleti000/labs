#!/bin/bash
ecorouter=100
srv=101
wks=102
function lab1 {
    echo "Подготовка сети"
    echo "auto vmbr$lab" >> "/etc/network/interfaces"
    echo "iface vmbr$lab inet manual" >> "/etc/network/interfaces"
    echo "	bridge-ports none" >> "/etc/network/interfaces"
    echo "	bridge-stp off" >> "/etc/network/interfaces"
    echo "	bridge-fd 0" >> "/etc/network/interfaces" 
    echo >> "/etc/network/interfaces"
    echo "Мост vmbr$lab создан"
    systemctl restart networking
    echo -e "\033[32m DONE \033[0m" 
    echo "Настройка виртуальных машин"
    nvm=$lab
    nvm1=$(($lab+1))
    qm clone $ecorouter $nvm --name "ecorouter"
    qm clone $srv $nvm1 --name AltSrv
    qm set $nvm --net0 vmxnet3=1C:87:76:40:00:00,bridge=vmbr9999 --net1 vmxnet3=1C:87:76:40:00:01,bridge=vmbr0 --net2 vmxnet3=1C:87:76:40:00:02,bridge=vmbr$lab --tags="lab1 mdk01.02"
    qm set $nvm1 --net0  vmxnet3,bridge=vmbr$lab --tags="lab1 eco"
    echo -e "\033[32m DONE \033[0m" 
    echo "Создание пользователя"
    pveum group add lab1
    pveum useradd lab1@pve --password P@ssw0rd --enable 1 --groups lab1
    pveum acl modify /vms/$nvm --roles PVEVMUser --users lab1@pve
    pveum acl modify /vms/$nvm1 --roles PVEVMUser --users lab1@pve
    echo -e "\033[32m DONE \033[0m" 
}



function main() {
    clear
    echo "+=========== Сделай выбор ============+"
    echo "|Развернуть лабораторные работы:1     |"
    echo "+-------------------------------------+"
    read -p  "Выбор: " choice


    case $choice in
        1)
            lab=1010
            lab1
        ;;
        *)
            echo "Нереализуемый выбор"
            exit 1
        ;;
    esac
}




main