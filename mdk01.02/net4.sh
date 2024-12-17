#!/bin/bash
    echo "Create Network"
    {
    echo "auto vmbr1013" >> "/etc/network/interfaces" ##ISP-HQ
    echo "iface vmbr1013 inet manual" >> "/etc/network/interfaces"
    echo "	bridge-ports none" >> "/etc/network/interfaces"
    echo "	bridge-stp off" >> "/etc/network/interfaces"
    echo "	bridge-fd 0" >> "/etc/network/interfaces" 
    echo >> "/etc/network/interfaces"

    echo "auto vmbr1014" >> "/etc/network/interfaces" #ISP-BR
    echo "iface vmbr1014 inet manual" >> "/etc/network/interfaces"
    echo "	bridge-ports none" >> "/etc/network/interfaces"
    echo "	bridge-stp off" >> "/etc/network/interfaces"
    echo "	bridge-fd 0" >> "/etc/network/interfaces" 
    echo >> "/etc/network/interfaces"

    echo "auto vmbr1015" >> "/etc/network/interfaces" #BR-BRSRV
    echo "iface vmbr1015 inet manual" >> "/etc/network/interfaces"
    echo "	bridge-ports none" >> "/etc/network/interfaces"
    echo "	bridge-stp off" >> "/etc/network/interfaces"
    echo "	bridge-fd 0" >> "/etc/network/interfaces" 
    echo >> "/etc/network/interfaces"
    echo "bridge-vlan-aware yes" >> "/etc/network/interfaces"
	echo "bridge-vids 2-4094" >> "/etc/network/interfaces"

    echo "auto vmbr1016" >> "/etc/network/interfaces" #HQ-HQSRV
    echo "iface vmbr1016 inet manual" >> "/etc/network/interfaces"
    echo "	bridge-ports none" >> "/etc/network/interfaces"
    echo "	bridge-stp off" >> "/etc/network/interfaces"
    echo "	bridge-fd 0" >> "/etc/network/interfaces" 
    echo "bridge-vlan-aware yes" >> "/etc/network/interfaces"
	echo "bridge-vids 2-4094" >> "/etc/network/interfaces"
    echo >> "/etc/network/interfaces"
    } &>/dev/null
    systemctl restart networking
    echo -e "\033[32m DONE \033[0m" 
    echo "Create VM"
    
    qm clone 100 1017 --name "HQ"
    qm clone 100 1018 --name "BR"
    qm clone 101 1016 --name ISP
    qm clone 101 1019 --name BRSRV
    qm clone 101 1020 --name HQSRV
    qm set 1016 --net0  vmxnet3,bridge=vmbr0 --net1  vmxnet3,bridge=vmbr1013  --net2  vmxnet3,bridge=vmbr1014 --tags="mdk01.02 net4" #ISP
    qm set 1017 --net0 vmxnet3=1C:87:76:40:00:00,bridge=vmbr9999 --net2 vmxnet3=1C:87:76:40:00:01,bridge=vmbr1013 --net3 vmxnet3=1C:87:76:40:00:02,bridge=vmbr1016 --tags="mdk01.02 net4" #HQ
    qm set 1018 --net0 vmxnet3=1C:87:76:40:00:03,bridge=vmbr9999 --net2 vmxnet3=1C:87:76:40:00:04,bridge=vmbr1014 --net3 vmxnet3=1C:87:76:40:00:05,bridge=vmbr1015 --tags="mdk01.02 net4" #BR
    qm set 1019 --net0  vmxnet3,bridge=vmbr1015,tag=200 --tags="mdk01.02 net4" #BRSRV
    qm set 1020 --net0  vmxnet3,bridge=vmbr1016,tag=100 --tags="mdk01.02 net4" #HQSRV
    
    echo -e "\033[32m DONE \033[0m" 
    echo "Create User"
    {
    pveum group add net
    pveum useradd net4@pve --password P@ssw0rd --enable 1 --groups net
    pveum acl modify /vms/1016 --roles PVEVMUser --users net4@pve
    pveum acl modify /vms/1017 --roles PVEVMUser --users net4@pve
    pveum acl modify /vms/1018 --roles PVEVMUser --users net4@pve
    pveum acl modify /vms/1019 --roles PVEVMUser --users net4@pve
    pveum acl modify /vms/1020 --roles PVEVMUser --users net4@pve
    } &>/dev/null
    echo -e "\033[32m DONE \033[0m\n\n"
    echo -e "\033[34m To login use:\033[0m\n\033[32mLogin:\033[31mnet4\n\033[32mPassword:\033[31mP@ssw0rd\033[0m"