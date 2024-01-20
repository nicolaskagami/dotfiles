#!/bin/sh

# General Stuff
sudo apt-get install -y -qq build-essential curl wget jq 
sudo apt-get install -y -qq i3
sudo apt install -y -qq lxappearance gtk-chtheme 

bash i3/install.sh
bash vim/install.sh
bash terminator/install.sh
bash greeter/install.sh
bash themes/install.sh

bash i3/build.sh
bash vim/build.sh
bash terminator/build.sh
bash greeter/build.sh
bash themes/build.sh
