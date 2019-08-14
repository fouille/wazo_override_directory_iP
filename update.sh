#!/bin/bash

usage() {
    cat >&3 <<EOF
Usage: $0 <Last IP address> <New IP address> <Pluging Device>
Change the ip address of the Wazo Phonebook
EOF
	exit 1
}

if [ "$#" -ne 3 ]; then
   usage
fi

replace() {
    local search=$1
    local replace=$2
    local using_pluging=$3
    # Note the double quotes
    echo "Last IP : ${search} / New IP : ${replace}"
    echo "Replace..."
    sed -i "s/${search}/${replace}/g" /var/lib/xivo-provd/jsondb/configs/base
    echo "Replaced, result :"
    cat /var/lib/xivo-provd/jsondb/configs/base
    clean ${using_pluging}
}

clean() {
    echo "Restart Wazo-Provd"
    systemctl restart xivo-provd
    echo "Done"
    echo "Reconfigure Devices Configuration ${using_pluging}"
    xivo-provd-cli -c 'devices.using_plugin("${using_pluging}").reconfigure()'
    echo "Done"
    echo "Synchronysing Devices ${using_pluging}"
    xivo-provd-cli -c 'devices.using_plugin("${using_pluging}").synchronize()'
    echo "Done"
    echo "All is good, bye"
}

replace ${1} ${2} ${3}
