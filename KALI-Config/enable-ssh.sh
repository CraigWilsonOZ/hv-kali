#!/bin/sh
#set -eu -o pipefail # fail on error and report it, debug all lines

echo KALI update and configure base VM
echo Checking for sudo access.

sudo -n true
test $? -eq 0 || exit 1 "you should have sudo privilege to run this script"

echo KALI update and configure base VM
echo you have 5 seconds to proceed ...
echo or
echo hit Ctrl+C to quit
echo -e "\n"
sleep 6

# KALI Configuration
# SSH enablement
echo "[+] Recreating SSH keys and starting SSH service"
# Removing SSH start up
sudo update-rc.d -f ssh remove
# Reset the start up with defaults
sudo update-rc.d -f ssh defaults
# Change the default SSH keys to new ones
cd /etc/ssh/
sudo mkdir /etc/ssh/default_kali_keys
sudo mv /etc/ssh/ssh_host_* /etc/ssh/default_kali_keys/
cd /etc/ssh/
sudo dpkg-reconfigure openssh-server
# Set the service to start
sudo systemctl enable ssh
# reboot or start service
sudo service ssh restart
