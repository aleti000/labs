#! /bin/bash
echo "Сетевые параметры SRV"
pvesh get /nodes/sa/qemu/1996/agent/network-get-interfaces --output-format json | jq '.result' | jq '.[]."ip-addresses"' | jq '.[]."ip-address"' | grep -v 127.0.0.1 | grep -v ::
echo "Сетевые параметры SRV1"
pvesh get /nodes/sa/qemu/1997/agent/network-get-interfaces --output-format json | jq '.result' | jq '.[]."ip-addresses"' | jq '.[]."ip-address"' | grep -v 127.0.0.1 | grep -v ::
echo "Сетевые параметры SRV2"
pvesh get /nodes/sa/qemu/1998/agent/network-get-interfaces --output-format json | jq '.result' | jq '.[]."ip-addresses"' | jq '.[]."ip-address"' | grep -v 127.0.0.1 | grep -v ::
echo "Сетевые параметры SRV3"
pvesh get /nodes/sa/qemu/1999/agent/network-get-interfaces --output-format json | jq '.result' | jq '.[]."ip-addresses"' | jq '.[]."ip-address"' | grep -v 127.0.0.1 | grep -v ::