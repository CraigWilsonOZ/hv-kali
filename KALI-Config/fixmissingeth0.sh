#!/bin/sh

echo KALI adding eth0
echo Checking for sudo access.

sudo -n true
test $? -eq 0 || exit 1 "you should have sudo privilege to run this script"

echo KALI adding eth0
echo you have 5 seconds to proceed ...
echo or
echo hit Ctrl+C to quit
echo -e "\n"
sleep 6

if [ cat /etc/network/interfaces |grep "auto eth" ]
    then
        sudo cat > /etc/network/interfaces <<EOF
auto eth0
iface eth0 inet dhcp
EOF
fi