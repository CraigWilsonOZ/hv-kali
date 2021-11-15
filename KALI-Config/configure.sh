#!/bin/sh
set -eu -o pipefail # fail on error and report it, debug all lines

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


echo "[+] Installing Visual Studio Code"
cd 
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

sudo apt install apt-transport-https
sudo apt update
sudo apt install code # or code-insiders

echo "[+] Installing Microsoft Edge"
## Setup
cd
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-beta.list'
sudo rm microsoft.gpg
## Install
sudo apt update
sudo apt install microsoft-edge-beta

echo "[+] Installing Azure Linux Agent"
## Setup
sudo apt install walinuxagent

sudo cat > /etc/waagent.conf <<EOF
#
# Azure Linux Agent Configuration	
#
Extensions.Enabled=y
Extensions.GoalStatePeriod=6
Extensions.GoalStateHistoryCleanupPeriod=1800
Provisioning.Agent=auto
Provisioning.DeleteRootPassword=n
Provisioning.RegenerateSshHostKeyPair=y
Provisioning.SshHostKeyPairType=rsa
Provisioning.MonitorHostName=y
Provisioning.DecodeCustomData=n
Provisioning.ExecuteCustomData=n
Provisioning.PasswordCryptId=6
Provisioning.PasswordCryptSaltLength=10
ResourceDisk.Format=y
ResourceDisk.Filesystem=ext4
ResourceDisk.MountPoint=/mnt/resource
ResourceDisk.MountOptions=None
ResourceDisk.EnableSwap=n
ResourceDisk.EnableSwapEncryption=n
ResourceDisk.SwapSizeMB=0
Logs.Verbose=n
Logs.Collect=n
Logs.CollectPeriod=3600
OS.AllowHTTP=n
OS.RootDeviceScsiTimeout=300
OS.EnableFIPS=n
OS.OpensslPath=None
OS.SshClientAliveInterval=180
OS.SshDir=/etc/ssh
HttpProxy.Host=None
HttpProxy.Port=None
EOF

echo "[+] Installing Azure CLI"
## Setup
cd 
sudo apt-get update
sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg

curl -sL https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list

sudo apt-get update
sudo apt-get install azure-cli

echo "[+] Final Update"
## Setup
sudo apt update
sudo apt upgrade -y