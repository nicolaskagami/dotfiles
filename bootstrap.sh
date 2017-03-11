#!/bin/sh

# General Stuff
sudo apt-get install -y -qq build-essential curl wget

sudo apt-get install -y -qq i3 lightdm

bash i3/install.sh
bash vim/install.sh
bash terminator/install.sh
bash zsh/install.sh

bash i3/build.sh
bash vim/build.sh
bash terminator/build.sh
bash zsh/build.sh
