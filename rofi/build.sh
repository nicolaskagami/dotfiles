#!/bin/bash
# Nicolas Silveira Kagami
# rofi builder

BASEDIR=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
BACKUP_FOLDER="$HOME/.dotfiles_backup"

ROFI_FILE="$BASEDIR/rofi.conf"
ROFI_LOCATION="$HOME/.config/rofi/config"

if ! [ -d $BACKUP_FOLDER ]
then
    mkdir $BACKUP_FOLDER
fi
if [ -f $ROFI_FILE ]
    then
    if [ -f $ROFI_LOCATION ]
    then
        echo "rofi configuration file detected: Backing up to $BACKUP_FOLDER"
        mv $ROFI_LOCATION $BACKUP_FOLDER/
    fi
    sudo ln -f -s $ROFI_FILE $ROFI_LOCATION
fi
