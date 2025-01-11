#! /bin/bash
########################Проверка GW
data=$(pvesh get /nodes/sa/qemu/1996/agent/get-host-name --output-format json | jq '.result' | tr -d '{' | tr -d '}' | tr -d '\n' | sed 's/^[ \t]*//')
echo -e "\033[34m$data\033[0m\n"
data=$(pvesh get /nodes/sa/qemu/1996/agent/network-get-interfaces --output-format json | jq '.result' | jq '.[]."ip-addresses"' | jq '.[]."ip-address"' | grep -v 127.0.0.1 | grep -v ::)
echo -e "\033[32mIP-addresses:\n\033[33m$data\033[0m\n"

data=$(qm guest exec 1996 systemctl status iptables |jq '."out-data"')
data1=$(echo -e $data |grep Active )
echo -e "\033[32mПараметры iptables -\n\033[0m \033[33m$data1\033[0m"

data=$(qm guest exec 1996 cat /etc/net/sysctl.conf|jq '."out-data"')
data1=$(echo -e $data | grep net.ipv4.ip_forward)
echo -e "\033[33m$data1\033[0m"

data=$(qm guest exec 1996 cat /etc/sysconfig/iptables|jq '."out-data"')
data1=$(echo -e $data |grep POSTROUTING | grep -v :)
echo -e "\033[33m$data1\033[0m\n\n"

########################Проверка Files
data=$(pvesh get /nodes/sa/qemu/1997/agent/get-host-name --output-format json | jq '.result' | tr -d '{' | tr -d '}' | tr -d '\n' | sed 's/^[ \t]*//')
echo -e "\033[34m$data\033[0m\n"
data=$(pvesh get /nodes/sa/qemu/1997/agent/network-get-interfaces --output-format json | jq '.result' | jq '.[]."ip-addresses"' | jq '.[]."ip-address"' | grep -v 127.0.0.1 | grep -v ::)
echo -e "\033[32mIP-addresses:\n\033[33m$data\033[0m\n"
########################Проверка DNS
data=$(pvesh get /nodes/sa/qemu/1998/agent/get-host-name --output-format json | jq '.result' | tr -d '{' | tr -d '}' | tr -d '\n' | sed 's/^[ \t]*//')
echo -e "\033[34m$data\033[0m\n"
data=$(pvesh get /nodes/sa/qemu/1998/agent/network-get-interfaces --output-format json | jq '.result' | jq '.[]."ip-addresses"' | jq '.[]."ip-address"' | grep -v 127.0.0.1 | grep -v ::)
echo -e "\033[32mIP-addresses:\n\033[33m$data\033[0m\n"
########################Проверка SRV
data=$(pvesh get /nodes/sa/qemu/1999/agent/get-host-name --output-format json | jq '.result' | tr -d '{' | tr -d '}' | tr -d '\n' | sed 's/^[ \t]*//')
echo -e "\033[34m$data\033[0m\n"
data=$(qm guest exec 1999 cat /etc/net/ifaces/ens18/options |jq '."out-data"')
data1=$(echo -e $data |grep BOOTPROTO |grep -v SYSTEMD)
echo -e "\033[33m$data1\033[0m"
data=$(pvesh get /nodes/sa/qemu/1999/agent/network-get-interfaces --output-format json | jq '.result' | jq '.[]."ip-addresses"' | jq '.[]."ip-address"' | grep -v 127.0.0.1 | grep -v ::)
echo -e "\033[32mIP-addresses:\n\033[33m$data\033[0m\n"