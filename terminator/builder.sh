#!/bin/bash
# Nicolas Silveira Kagami
# terminator builder

BASEDIR=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
BACKUP_FOLDER="$HOME/.dotfiles_backup"

TERMINATOR_FILE="$BASEDIR/config"
TERMINATOR_LOCATION="$HOME/.config/terminator/config"

if ! [ -d $BACKUP_FOLDER ]
then
    mkdir $BACKUP_FOLDER
fi
if [ -f $TERMINATOR_FILE ]
    then
    if [ -f $TERMINATOR_LOCATION ]
    then
        echo "terminator configuration file detected: Backing up to $BACKUP_FOLDER"
        mv $TERMINATOR_LOCATION $BACKUP_FOLDER/
    else
        mkdir $HOME/.config/terminator
    fi
    ln -s $TERMINATOR_FILE $TERMINATOR_LOCATION
fi
