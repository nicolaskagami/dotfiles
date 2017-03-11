#!/bin/sh
echo "Installing terminator (repo)"
check=`which terminator`
if [ $? ]
then
    echo "Already Installed"
else
    sudo apt-get install -y terminator
fi
