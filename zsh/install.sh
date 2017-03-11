#!/bin/sh
echo "Installing zsh (repo)"
check=`which zsh`
if [ $? ]
then
    echo "Already Installed"
else
    sudo apt-get install -y zsh
fi
