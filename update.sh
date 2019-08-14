#!/bin/bash

set +x

usage() {
    cat >&3 <<EOF
Usage: $0 <new IP address> <new gateway>
Change the VOIP ip address of the engine
EOF
	exit 1
}

if [ "$#" -ne 3 ]; then
   usage
fi

#IP="${1}"
#GATEWAY="${2}"
#last_ip=$(echo ${1} | awk -F. '{printf "%d\.%d\.%d\.%d\\", $1,$2,$3,$4}')
#new_ip=$(echo ${2} | awk -F. '{printf "%d\.%d\.%d\.%d\\", $1,$2,$3,$4}')

#echo "${last_ip} and ${new_ip}"
#echo "sed -i '.bak' 's/"X_xivo_phonebook_ip":"${1}"/"X_xivo_phonebook_ip":"${2}"/g' base"
#sed -i '.bak' 's/\"X\_xivo\_phonebook\_ip\"\:\"${last_ip}\"/\"X\_xivo\_phonebook\_ip\"\:\"tessst\"/g' base

#sed -i '.bak' 's/\"X\_xivo\_phonebook\_ip\"\:\"192\.168\.1\.20\"/\"X\_xivo\_phonebook\_ip\"\:\"tessst\"/g' base


#sed -i '.bak' 's/"X_xivo_phonebook_ip":"${last_ip}"/"X_xivo_phonebook_ip":"${new_ip}"/g' base
#cat base
#rm base.bak
#sed -i '.bak' 's/\"X\_xivo\_phonebook\_ip\"\:\"tessst\"/\"X\_xivo\_phonebook\_ip\"\:\"192\.168\.1\.20\"/g' base
#cat base
#rm base.bak

replace() {
    local search=$1
    local replace=$2
    local using_pluging=$3
    # Note the double quotes
    echo "Last IP : ${search} / New IP : ${replace}"
    echo "Replace..."
    sed -i "" "s/${search}/${replace}/g" /var/lib/xivo-provd/jsondb/configs/base
    echo "Replaced, result :"
    cat /var/lib/xivo-provd/jsondb/configs/base
    echo "Restart Wazo-Provd"
    systemctl restart xivo-provd
    echo "Done"
    echo "Reconfigure Devices Configuration"
    xivo-provd-cli -c 'devices.using_plugin("${using_pluging}").reconfigure()'
    echo "Done"
    echo "Synchronysing Devices"
    xivo-provd-cli -c 'devices.using_plugin("${using_pluging}").synchronize()'
    echo "Done"
    echo "All is good, bye"
}

replace ${1} ${2} ${3}
