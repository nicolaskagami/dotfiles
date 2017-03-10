#!/bin/bash
# Nicolas Silveira Kagami
# i3 builder

BASEDIR=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
BACKUP_FOLDER="$HOME/.dotfiles_backup"

I3_FILE="$BASEDIR/config"
I3_LOCATION="$HOME/.i3/config"

I3_STATUS="$BASEDIR/status/config"
I3_STATUS_LOCATION="$HOME/.config/i3status/config"


if ! [ -d $BACKUP_FOLDER ]
then
    mkdir $BACKUP_FOLDER
fi
if [ -f $I3_FILE ]
    then
    if [ -f $I3_LOCATION ]
    then
        echo "i3 configuration file detected: Backing up to $BACKUP_FOLDER"
        mv $I3_LOCATION $BACKUP_FOLDER/
    fi
    ln -s $I3_FILE $I3_LOCATION
fi


if [ -f $I3_STATUS ]
then
    if [ -f $I3_STATUS_LOCATION ]
    then
        echo "i3 status configuration file detected: Backing up to $BACKUP_STATUS"
        mv $I3_STATUS_LOCATION $BACKUP_FOLDER/
    else
        mkdir $HOME/.config/i3status
    fi
    ln -s $I3_STATUS $I3_STATUS_LOCATION
fi


