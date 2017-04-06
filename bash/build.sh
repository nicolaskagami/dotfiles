#!/bin/bash
# Nicolas Silveira Kagami
# Bash builder

BASEDIR=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
BACKUP_FOLDER="$HOME/.dotfiles_backup"

BASH_FILE="$BASEDIR/bashrc"
BASH_LOCATION="$HOME/.bashrc"

if ! [ -d $BACKUP_FOLDER ]
then
    mkdir $BACKUP_FOLDER
fi

if [ -f $BASH_FILE ]
    then
    if [ -f $BASH_LOCATION ]
    then
        echo "bash configuration file detected: Backing up to $BACKUP_FOLDER"
        mv $BASH_LOCATION $BACKUP_FOLDER/
    fi
    sudo ln -f -s $BASH_FILE $BASH_LOCATION
fi
