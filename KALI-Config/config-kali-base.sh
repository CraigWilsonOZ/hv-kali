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

echo "[+] Installing Xfce, this will take a while"
sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get install -y kali-desktop-xfce xrdp

echo "[+] Configuring XRDP to listen to port 3390 (but not starting the service)..."
#sudo sed -i 's/port=3389/port=3390/g' /etc/xrdp/xrdp.ini
sudo systemctl enable xrdp --now
sudo /etc/init.d/xrdp start

# How to Fix "Authentication is required to create a color profile/managed device"
# ref https://devanswers.co/how-to-fix-authentication-is-required-to-create-a-color-profile-managed-device-on-ubuntu-20-04-20-10/
# Create a new profile for 

sudo cat > /etc/polkit-1/localauthority.conf.d/02-allow-colord.conf <<EOF
polkit.addRule(function(action, subject) {
 if ((action.id == "org.freedesktop.color-manager.create-device" ||
 action.id == "org.freedesktop.color-manager.create-profile" ||
 action.id == "org.freedesktop.color-manager.delete-device" ||
 action.id == "org.freedesktop.color-manager.delete-profile" ||
 action.id == "org.freedesktop.color-manager.modify-device" ||
 action.id == "org.freedesktop.color-manager.modify-profile") &&
 subject.isInGroup("{users}")) {
 return polkit.Result.YES;
 }
});
EOF

echo "[+] Final Update"
## Setup
sudo apt update
sudo apt upgrade -y

echo "[+] Next Steps"
## Setup
echo "Main setup completed, next run kali-tweaks and enable virtualization"
