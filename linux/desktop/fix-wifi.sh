#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install linux-headers-generic build-essential git
git clone https://github.com/abperiasamy/rtl8812AU_8821AU_linux.git
cd rtl8812AU_8821AU_linux
make clean && make
sudo make install
sudo modprobe rtl8812au
