#!/bin/sh
#set -eu -o pipefail # fail on error and report it, debug all lines

echo KALI installing Azure Agent
echo Checking for sudo access.

sudo -n true
test $? -eq 0 || exit 1 "you should have sudo privilege to run this script"

echo KALI update and configure base VM
echo you have 5 seconds to proceed ...
echo or
echo hit Ctrl+C to quit
echo -e "\n"
sleep 6


echo "[+] Installing Azure Linux Agent"
## Setup
sudo apt install waagent -y

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
