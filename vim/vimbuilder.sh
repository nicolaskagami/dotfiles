#!/bin/bash
# Nicolas Silveira Kagami
# VIM builder

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
