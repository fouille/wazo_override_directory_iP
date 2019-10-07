#!/bin/bash

NewIP=$(whiptail --title "Hello Wazo HELP / IP PhoneBook" --inputbox "Please insert new IP address" 10 60 1.1.1.1 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
{
    echo -e "XXX\n0\nUpdate Please Wait... \nXXX"
<< EOF wazo-provd-cli
base = configs.get('base')
base['raw_config']['X_xivo_phonebook_ip'] = '$NewIP'
configs.update(base)
exit()
EOF
    sleep 1
    echo -e "XXX\n50\nUpdate IP... Done.\nXXX"
    sleep 0.5

    echo -e "XXX\n50\nRestart services... \nXXX"
    systemctl restart wazo-provd wazo-phoned

    echo -e "XXX\n100\nRestart services... Done.\nXXX"
    sleep 0.5

} | whiptail --gauge "Veuillez patienter pendant l'installation" 6 60 0

whiptail --title "Hello Wazo HELP / IP PhoneBook" --msgbox "Please reset or re-provision your devices\nHave a nice day :-) Wazo Support." 10 60

else
    echo "Y've cancel... :-("
fi
