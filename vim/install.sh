#!/bin/sh
echo "Installing vim (repo)"
check=`which vim`
if [ $? = 0 ]
then
    echo "Already Installed"
else
    sudo apt-get install -qq -y vim 
fi
sudo apt-get install -qq -y cscope exuberant-ctags clang
update-alternatives --config ctags
