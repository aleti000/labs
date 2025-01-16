#! /bin/bash
########################Проверка GW
echo -e "\033[95mИмена машин:\033[0m"
    #Name_GW
        data=$(pvesh get /nodes/sa/qemu/1996/agent/get-host-name --output-format json | jq '.result' | tr -d '{' | tr -d '}' | tr -d '\n' | sed 's/^[ \t]*//')
        echo -e "\033[32m$data\033[0m"
    #name_Files
        data=$(pvesh get /nodes/sa/qemu/1997/agent/get-host-name --output-format json | jq '.result' | tr -d '{' | tr -d '}' | tr -d '\n' | sed 's/^[ \t]*//')
        echo -e "\033[32m$data\033[0m"    
    #name_dns
        data=$(pvesh get /nodes/sa/qemu/1998/agent/get-host-name --output-format json | jq '.result' | tr -d '{' | tr -d '}' | tr -d '\n' | sed 's/^[ \t]*//')
        echo -e "\033[32m$data\033[0m"   
    #name_SRV
        data=$(pvesh get /nodes/sa/qemu/1999/agent/get-host-name --output-format json | jq '.result' | tr -d '{' | tr -d '}' | tr -d '\n' | sed 's/^[ \t]*//')
        echo -e "\033[32m$data\033[0m"    
echo -e "\033[95m\nIP-адреса:\033[0m"    
    #IP_GW
        data=$(pvesh get /nodes/sa/qemu/1996/agent/network-get-interfaces --output-format json | jq '.result' | jq '.[]."ip-addresses"' | jq '.[]."ip-address"' | grep -v 127.0.0.1 | grep -v ::)
        echo -e "\033[32mIP-addresses GW:\n\033[33m$data\033[0m"
    #ip_address_Files
        data=$(pvesh get /nodes/sa/qemu/1997/agent/network-get-interfaces --output-format json | jq '.result' | jq '.[]."ip-addresses"' | jq '.[]."ip-address"' | grep -v 127.0.0.1 | grep -v ::)
        echo -e "\033[32mIP-addresses Files:\n\033[33m$data\033[0m"
    #ip-address_dns
        data=$(pvesh get /nodes/sa/qemu/1998/agent/network-get-interfaces --output-format json | jq '.result' | jq '.[]."ip-addresses"' | jq '.[]."ip-address"' | grep -v 127.0.0.1 | grep -v ::)
        echo -e "\033[32mIP-addresses DNS:\n\033[33m$data\033[0m"
echo -e "\033[95m\nПроверка DHCP:\033[0m"
        data=$(qm guest exec 1996 systemctl status iptables |jq '."out-data"')
        data1=$(echo -e $data |grep Active )
        echo -e "\033[32mDHCP -\033[0m \033[33m$data1\033[0m"
    #ip-address_srv
        data=$(pvesh get /nodes/sa/qemu/1999/agent/network-get-interfaces --output-format json | jq '.result' | jq '.[]."ip-addresses"' | jq '.[]."ip-address"' | grep -v 127.0.0.1 | grep -v ::)
        echo -e "\033[32mIP-addresses SRV:\n\033[33m$data\033[0m" 
        data=$(qm guest exec 1999 cat /etc/net/ifaces/ens18/options |jq '."out-data"')
        data1=$(echo -e $data |grep BOOTPROTO |grep -v SYSTEMD)
        echo -e "\033[33m$data1\033[0m"
echo -e "\033[95m\nПроверка доступа в сеть интернет\033[0m"
    #files
        data=$(qm guest exec 1997 -- ping 8.8.8.8 -c 1 |jq '."out-data"')
        data1=$(echo -e $data |grep received)
        echo -e "\033[32mFiles:\033[0m\n\033[32m$data1\033[0m"
    #DNS
        data=$(qm guest exec 1998 -- ping 8.8.8.8 -c 1 |jq '."out-data"')
        data1=$(echo -e $data |grep received)
        echo -e "\033[32mDNS:\033[0m\n\033[32m$data1\033[0m"
    #srv
        data=$(qm guest exec 1999 -- ping 8.8.8.8 -c 1 |jq '."out-data"')
        data1=$(echo -e $data |grep received)
        echo -e "\033[32mSRV:\033[0m\n\033[32m$data1\033[0m"
echo -e "\033[95m\nПараметры iptables\033[0m"    
    #IPTABLES_GW
        data=$(qm guest exec 1996 systemctl status iptables |jq '."out-data"')
        data1=$(echo -e $data |grep Active )
        echo -e "\033[33m$data1\033[0m"
        data=$(qm guest exec 1996 cat /etc/net/sysctl.conf|jq '."out-data"')
        data1=$(echo -e $data | grep net.ipv4.ip_forward)
        echo -e "\033[33m$data1\033[0m"
        data=$(qm guest exec 1996 cat /etc/sysconfig/iptables|jq '."out-data"')
        data1=$(echo -e $data |grep POSTROUTING | grep -v :)
        echo -e "\033[33m$data1\033[0m"
        data=$(qm guest exec 1996 cat /etc/sysconfig/iptables|jq '."out-data"')
        data1=$(echo -e $data |grep ACCEPT | grep -v :)
        echo -e "\033[33m$data1\033[0m"
        data=$(qm guest exec 1996 cat /etc/sysconfig/iptables|jq '."out-data"')
        data1=$(echo -e $data |grep DROP | grep -v :)
        echo -e "\033[33m$data1\033[0m"
        data=$(qm guest exec 1996 cat /etc/sysconfig/iptables|jq '."out-data"')
        data1=$(echo -e $data |grep REJECT | grep -v :)
        echo -e "\033[33m$data1\033[0m"
 echo -e "\033[95m\nПроверка SSH:\033[0m"
    #SSH_GW
    echo -e "\033[32mGW :\033[0m"
         data=$(qm guest exec 1996 systemctl status sshd |jq '."out-data"')
        data1=$(echo -e $data |grep Active )
        echo -e "\033[33m$data1\033[0m"
        data=$(qm guest exec 1996 cat /etc/openssh/sshd_config|jq '."out-data"')
        data1=$(echo -e $data | grep Port |grep -v \#Gateway)
        echo -e "\033[33m$data1\033[0m"
        data=$(qm guest exec 1996 cat /etc/openssh/sshd_config|jq '."out-data"')
        data1=$(echo -e $data | grep PermitRootLogin |grep -v "the setting of")
        echo -e "\033[33m$data1\033[0m"
        data=$(qm guest exec 1996 cat /etc/openssh/sshd_config|jq '."out-data"')
        data1=$(echo -e $data | grep PasswordAuthentication |grep -v PAM)
        echo -e "\033[33m$data1\033[0m"
    #SSH_Files
    echo -e "\033[32mFiles :\033[0m"
         data=$(qm guest exec 1997 systemctl status sshd |jq '."out-data"')
        data1=$(echo -e $data |grep Active )
        echo -e "\033[33m$data1\033[0m"
        data=$(qm guest exec 1997 cat /etc/openssh/sshd_config|jq '."out-data"')
        data1=$(echo -e $data | grep Port |grep -v \#Gateway)
        echo -e "\033[33m$data1\033[0m"
        data=$(qm guest exec 1997 cat /etc/openssh/sshd_config|jq '."out-data"')
        data1=$(echo -e $data | grep PermitRootLogin |grep -v "the setting of")
        echo -e "\033[33m$data1\033[0m"
        data=$(qm guest exec 1997 cat /etc/openssh/sshd_config|jq '."out-data"')
        data1=$(echo -e $data | grep PasswordAuthentication |grep -v PAM)
        echo -e "\033[33m$data1\033[0m"
    #SSH_DNS
    echo -e "\033[32mDNS :\033[0m"
         data=$(qm guest exec 1998 systemctl status sshd |jq '."out-data"')
        data1=$(echo -e $data |grep Active )
        echo -e "\033[33m$data1\033[0m"
        data=$(qm guest exec 1998 cat /etc/openssh/sshd_config|jq '."out-data"')
        data1=$(echo -e $data | grep Port |grep -v \#Gateway)
        echo -e "\033[33m$data1\033[0m"
        data=$(qm guest exec 1998 cat /etc/openssh/sshd_config|jq '."out-data"')
        data1=$(echo -e $data | grep PermitRootLogin |grep -v "the setting of")
        echo -e "\033[33m$data1\033[0m"
        data=$(qm guest exec 1998 cat /etc/openssh/sshd_config|jq '."out-data"')
        data1=$(echo -e $data | grep PasswordAuthentication |grep -v PAM)
        echo -e "\033[33m$data1\033[0m"
    #SSH_SRV
    echo -e "\033[32mSRV :\033[0m"
         data=$(qm guest exec 1999 systemctl status sshd |jq '."out-data"')
        data1=$(echo -e $data |grep Active )
        echo -e "\033[33m$data1\033[0m"
        data=$(qm guest exec 1999 cat /etc/openssh/sshd_config|jq '."out-data"')
        data1=$(echo -e $data | grep Port |grep -v \#Gateway)
        echo -e "\033[33m$data1\033[0m"
        data=$(qm guest exec 1999 cat /etc/openssh/sshd_config|jq '."out-data"')
        data1=$(echo -e $data | grep PermitRootLogin |grep -v "the setting of")
        echo -e "\033[33m$data1\033[0m"
        data=$(qm guest exec 1999 cat /etc/openssh/sshd_config|jq '."out-data"')
        data1=$(echo -e $data | grep PasswordAuthentication |grep -v PAM)
        echo -e "\033[33m$data1\033[0m"  
    #RAID_Files
    echo -e  "\033[95m\nПроверка RAID:\033[0m" 
        data=$(qm guest exec 1997 lsblk | jq '."out-data"')
        echo -e "\033[33m$data\033[0m"