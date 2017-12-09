#!/bin/sh
echo "Installing cmus (repo)"
check=`which cmus`
if [ $? = 0 ]
then
    echo "Already Installed"
else
    sudo apt-get install -y cmus
fi
