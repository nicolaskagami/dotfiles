#!/bin/sh
echo "Installing terminator (repo)"
check=`whi= 0 ch terminator`
if [ $? = 0 ]
then
    echo "Already Installed"
else
    sudo apt-get install -y terminator
fi
