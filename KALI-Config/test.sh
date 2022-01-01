#!/bin/sh

echo Test - Test Script
echo Checking for sudo access.

sudo -n true
test $? -eq 0 || exit 1 "you should have sudo privilege to run this script"

echo KALI update and configure base VM
echo you have 5 seconds to proceed ...
echo or
echo hit Ctrl+C to quit
echo -e "\n"
sleep 6
