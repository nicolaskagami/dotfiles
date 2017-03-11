#!/bin/sh
echo "Installing git (repo)"
check=`which git`
if [ $? ]
then
    echo "Already Installed"
else
    sudo apt-get install -y git
fi
