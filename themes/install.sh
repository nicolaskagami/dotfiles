#!/bin/sh
echo "Installing Arc Theme"
if [ -f /etc/apt/sources.list.d/arc-theme.list ]
then
    echo "Already Installed"
else
    sudo echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/Debian_8.0/ /' > /etc/apt/sources.list.d/arc-theme.list 
    sudo apt-get update
    sudo apt-get install arc-theme
fi
