#!/bin/sh

sudo rm -rf LCD-show 
git clone https://github.com/CraigWilsonOZ/LCD-show.git
chmod -R 755 LCD-show 
cd LCD-show/
sudo ./MHS35-show
