#!/bin;bash
# Nicolas Silveira Kagami
# VIM builder

VIMRC_FILE="./vimrc"
VIM_FOLDER="./vim"

if [ -f $VIMRC_FILE ]
then
    cp $VIMRC_FILE $HOME/.vimrc
else
    echo "Vim Configurations File not found"
fi
if [ -d $HOME/.vim ]
then
    echo "Vim Folder already exists (.vim)"  
else
    mkdir $HOME/.vim	
fi
cp -r $VIM_FOLDER/* $HOME/.vim
