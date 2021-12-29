#!/bin/sh

echo KALI - Installing additional software
echo Checking for sudo access.

sudo -n true
test $? -eq 0 || exit 1 "you should have sudo privilege to run this script"

echo KALI update and configure base VM
echo you have 5 seconds to proceed ...
echo or
echo hit Ctrl+C to quit
echo -e "\n"
sleep 6

echo "[+] Installing ExpressVPN"
## Setup
wget -O ~/Downloads/expressvpn.deb https://www.expressvpn.works/clients/linux/expressvpn_3.13.0.8-1_amd64.deb
sudo dpkg -i ~/Downloads/expressvpn.deb

echo "[+] Activate ExpressVPN"
## configuration
echo "Access https://www.expressvpn.com/subscriptions to get your activation code"
expressvpn activate
expressvpn preferences set send_diagnostics false

