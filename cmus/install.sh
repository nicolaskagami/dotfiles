#!/bin/sh
echo "Installing cmus (repo)"
check=`which cmus`
if [ $? ]
then
    echo "Already Installed"
else
    sudo apt-get install -y cmus
fi
