    echo "Create Network"
    {
    echo "auto vmbr1999" >> "/etc/network/interfaces"
    echo "iface vmbr1999 inet manual" >> "/etc/network/interfaces"
    echo "	bridge-ports none" >> "/etc/network/interfaces"
    echo "	bridge-stp off" >> "/etc/network/interfaces"
    echo "	bridge-fd 0" >> "/etc/network/interfaces" 
    echo >> "/etc/network/interfaces"
    } &>/dev/null
    systemctl restart networking
    echo -e "\033[32m DONE \033[0m" 
    echo "Create VM"
    {
       qm clone 101 1996 --name GW
       qm clone 101 1997 --name Files
       qm clone 101 1998 --name DNS
       qm clone 101 1999 --name SRV
       qm set 1996 --net0  vmxnet3,bridge=vmbr0 --net1  vmxnet3,bridge=vmbr1999 --serial0 socket --agent enabled=1 --tags="mdk02.01 exam"
       qm set 1997 --net0  vmxnet3,bridge=vmbr1999 --serial0 socket --virtio1 local-lvm:1 --virtio2 local-lvm:1 --virtio3 local-lvm:1 --virtio4 local-lvm:1 --agent enabled=1 --tags="mdk02.01 exam"
       qm set 1998 --net0  vmxnet3,bridge=vmbr1999 --serial0 socket --agent enabled=1 --tags="mdk02.01 exam"
       qm set 1999 --net0  vmxnet3,bridge=vmbr1999 --serial0 socket --agent enabled=1 --tags="mdk02.01 exam"
    } &> /dev/null
    echo -e "\033[32m DONE \033[0m" 
    echo "Create User"
    {
    pveum group add adm
    pveum useradd examadm@pve --password P@ssw0rd --enable 1 --groups adm
    pveum acl modify /vms/1996 --roles PVEVMUser --users examadm@pve
    pveum acl modify /vms/1997 --roles PVEVMUser --users examadm@pve
    pveum acl modify /vms/1998 --roles PVEVMUser --users examadm@pve
    pveum acl modify /vms/1999 --roles PVEVMUser --users examadm@pve
        } &>/dev/null
    echo -e "\033[32m DONE \033[0m\n\n"
    echo -e "\033[34m To login use:\033[0m\n\033[32mLogin:\033[31mexamadm\n\033[32mPassword:\033[31mP@ssw0rd\033[0m"