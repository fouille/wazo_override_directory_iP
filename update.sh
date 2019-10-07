#!/bin/bash

bye() {
whiptail --title "Hello Wazo HELP / IP PhoneBook" --msgbox "Please reset or re-provision your devices\nHave a nice day :-) Wazo Support$
}

autorize_subnets() {
IP_authorize=$(whiptail --title "Hello Wazo HELP / IP Authorize Subnet" --inputbox "Please insert Public IP to authorize\nExemple :\nFo$

exitstatus=$?
if [ $exitstatus = 0 ]; then
{
    echo -e "XXX\n0\nAdd IP Please Wait... \nXXX"
    touch /etc/wazo-phoned/conf.d/010-subnets.yml
    cat > /etc/wazo-phoned/conf.d/010-subnets.yml <<EOF
debug: yes
rest_api:
  authorized_subnets: [$IP_authorize]
EOF
    echo -e "XXX\n50\nAdd IP... Done.\nXXX"
    sleep 0.5

    echo -e "XXX\n50\nRestart service... \nXXX"
    systemctl restart wazo-phoned

    echo -e "XXX\n100\nRestart service... Done.\nXXX"
    sleep 0.5

} | whiptail --gauge "Veuillez patienter" 6 60 0

whiptail --title "Hello Wazo HELP / IP Authorize Subnet" --msgbox "$IP_authorize has been added to the authorize subnets" 10 60

fi

}

NewIP=$(whiptail --title "Hello Wazo HELP / IP PhoneBook" --inputbox "Please enter WAZO UC Engine public IP" 10 60 3>&1 1>&2 2>&3)

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
    echo -e "XXX\n50\nUpdate IP... Done.\nXXX"
    sleep 0.5

    echo -e "XXX\n50\nRestart services... \nXXX"
    systemctl restart wazo-provd wazo-phoned

    echo -e "XXX\n100\nRestart services... Done.\nXXX"
    sleep 0.5

} | whiptail --gauge "Veuillez patienter" 6 60 0

  if (whiptail --title "Hello Wazo HELP / IP Authorize Subnet" --yesno "Would you configure Authorize Subnets ?\nFor security reason th$
          autorize_subnets
  fi

bye

else
    echo "Y've cancel... :-("
fi
