#!/bin/sh
 
sudo apt-get install libraspberrypi-dev raspberrypi-kernel-headers

sudo rm -rf LCD-show 
git clone https://github.com/CraigWilsonOZ/LCD-show.git
chmod -R 755 LCD-show 
cd LCD-show/
sudo ./MHS35-show

sudo rm -rf LCD-show-kali
git clone https://github.com/CraigWilsonOZ/LCD-show-kali.git
chmod -R 755 LCD-show -kali
cd LCD-show-kali/
sudo ./MHS35-show
