#!/bin/bash
# Nicolas Silveira Kagami
# Zsh builder

BASEDIR=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
BACKUP_FOLDER="$HOME/.dotfiles_backup"

ZSH_FILE="$BASEDIR/zshrc"
ZSH_LOCATION="$HOME/.zshrc"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

if ! [ -d $BACKUP_FOLDER ]
then
    mkdir $BACKUP_FOLDER
fi

if [ -f $ZSH_FILE ]
    then
    if [ -f $ZSH_LOCATION ]
    then
        echo "zsh configuration file detected: Backing up to $BACKUP_FOLDER"
        mv $ZSH_LOCATION $BACKUP_FOLDER/
    fi
    sudo ln -f -s $ZSH_FILE $ZSH_LOCATION
fi
