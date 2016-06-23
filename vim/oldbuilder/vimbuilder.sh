#!/bin/bash
# Nicolas Silveira Kagami
# VIM builder

sudo apt-get install build-essential python-dev
sudo apt-get install libncurses5-dev libgnome2-dev libgnomeui-dev libgtk2.0-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev ruby-dev mercurial
sudo apt-get -f install
sudo apt-get remove vim vim-runtime gvim
sudo apt-get remove vim-tiny vim-common vim-gui-common

cd ~
hg clone https://code.google.com/p/vim/
cd vim
./configure --with-features=huge --enable-multibyte --enable-rubyinterp --enable-pythoninterp --with-python-config-dir=/usr/lib/python2.7/config --enable-perlinterp --enable-luainterp --enable-gui=gtk2 --enable-cscope --prefix=/usr
make VIMRUNTIMEDIR=/usr/share/vim/vim74
make install
update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1
update-alternatives --set editor /usr/bin/vim
update-alternatives --install /usr/bin/vi vi /usr/bin/vim 1
update-alternatives --set vi /usr/bin/vim



BASEDIR=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

VIMRC_FILE="$BASEDIR/vimrc"
VIM_FOLDER="$BASEDIR/vimfolder"

if [ -f $VIMRC_FILE ]
then
    cp $VIMRC_FILE $HOME/.vimrc
else
    echo "Vim Configurations File not found"
    exit
fi
if [ -d $HOME/.vim ]
then
    #echo "Vim Folder already exists (.vim)"  
    cp $VIM_FOLDER $HOME/.vim
else
    mkdir $HOME/.vim
fi
cp -r $VIM_FOLDER/* $HOME/.vim
git clone https://github.com/gmarik/Vundle.vim ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
cd ~/.vim/bundle/YouCompleteMe
./install.sh --clang-completer
