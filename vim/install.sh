#!/bin/sh
echo "Installing vim (repo)"
check=`which vim`
if [ $? ]
then
    echo "Already Installed"
else
    sudo apt-get install -y vim
fi
