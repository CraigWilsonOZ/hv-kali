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

echo "[+] Installing Visual Studio Code"
cd 
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

sudo apt update
sudo apt install apt-transport-https
sudo apt install code -y # or code-insiders

echo "[+] Installing Microsoft Edge"
## Setup
cd
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-beta.list'
sudo rm microsoft.gpg
## Install
sudo apt update
sudo apt install microsoft-edge-beta -y

echo "[+] Installing Azure CLI"
## Setup
cd 
sudo apt-get update
sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg -y

curl -sL https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

#AZ_REPO=$(lsb_release -cs)
AZ_REPO=focal
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list

sudo apt-get update
sudo apt-get install azure-cli -y

echo "[+] Installing Microsoft Teams"
## Setup
wget -O ~/Downloads/MSteams.deb https://go.microsoft.com/fwlink/p/?LinkID=2112886
sudo dpkg -i ~/Downloads/MSteams.deb

echo "[+] Installing SNAPD"
## Setup
sudo apt update
sudo apt install snapd
sudo systemctl start snapd  
sudo snap install core

echo "[+] Installing Discord"
## Setup
sudo snap install discord
sudo snap install postman

# Linked SNAPD folder to applications for desktop icons
sudo ln -s /var/lib/snapd/desktop/applications/ /usr/share/applications/snap 