#!/bin/bash
# Nicolas Silveira Kagami
# GTK builder

BASEDIR=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
BACKUP_FOLDER="$HOME/.dotfiles_backup"

GTKRC2_FILE="$BASEDIR/gtkrc2"
GTKRC2_LOCATION="$HOME/.gtkrc-2.0"

GTKRC3_FILE="$BASEDIR/gtkrc3"
GTKRC3_LOCATION="$HOME/.config/gtk-3.0/settings.ini"

if ! [ -d $BACKUP_FOLDER ]
then
    mkdir $BACKUP_FOLDER
fi

if [ -f $GTKRC2_FILE ]
then
    if [ -f $GTKRC2_LOCATION ]
    then
        echo "GTK2 configuration file detected: Backing up to $BACKUP_FOLDER"
        mv $GTKRC2_LOCATION $BACKUP_FOLDER/
    fi
    sudo ln -f -s $GTKRC2_FILE $GTKRC2_LOCATION
fi

if [ -f $GTKRC3_FILE ]
then
    if [ -f $GTKRC3_LOCATION ]
    then
        echo "GTK3 configuration file detected: Backing up to $BACKUP_FOLDER"
        mv $GTKRC3_LOCATION $BACKUP_FOLDER/
    elif ! [ -d $HOME/.config/gtk-3.0 ]
    then
        mkdir $HOME/.config/gtk-3.0
    fi
fi
sudo ln -f -s $GTKRC3_FILE $GTKRC3_LOCATION
