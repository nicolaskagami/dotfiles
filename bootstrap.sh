#!/bin/sh

# General Stuff
sudo apt-get install -y build-essential curl wget vim

sudo apt-get install -y i3 lightdm terminator zsh oh-my-zsh cmus

cd i3
bash ./builder.sh
cd terminator 
bash ./builder.sh
cd zsh 
bash ./builder.sh
