#!/bin/bash
# Nicolas Silveira Kagami
# VIM builder

BASEDIR=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
BACKUP_FOLDER="$HOME/.dotfiles_backup"

VIMRC_FILE="$BASEDIR/vimrc"
VIMRC_LOCATION="$HOME/.vimrc"

VIM_FOLDER="$BASEDIR/vimfolder"
VIM_FOLDER_LOCATION="$HOME/.vim"

if ! [ -d $BACKUP_FOLDER ]
then
    mkdir $BACKUP_FOLDER
fi

if [ -f $VIMRC_FILE ]
then
    if [ -f $VIMRC_LOCATION ]
    then
        echo "Vim configuration file detected: Backing up to $BACKUP_FOLDER"
        mv $VIMRC_LOCATION $BACKUP_FOLDER/
    fi
    ln -s $VIMRC_FILE $VIMRC_LOCATION
fi

if [ -d $VIM_FOLDER ]
then
    if [ -d $VIM_FOLDER_LOCATION ]
    then
        echo "Vim configuration folder detected: Backing up to $BACKUP_FOLDER"
        mv $VIM_FOLDER_LOCATION $BACKUP_FOLDER/
    fi
    ln -s $VIM_FOLDER $VIM_FOLDER_LOCATION
fi

git clone https://github.com/gmarik/Vundle.vim ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
