#!/bin/bash
# Nicolas Silveira Kagami
# LIGHTDM builder

BASEDIR=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
BACKUP_FOLDER="$HOME/.dotfiles_backup"

LIGHTDMRC_FILE="$BASEDIR/lightdm.conf"
LIGHTDMRC_LOCATION="/etc/lightdm/lightdm.conf"
LIGHTDM_GREETER_RC_FILE="$BASEDIR/lightdm-gtk-greeter.conf"
LIGHTDM_GREETER_RC_LOCATION="/etc/lightdm/lightdm-gtk-greeter.conf"

if ! [ -d $BACKUP_FOLDER ]
then
    mkdir $BACKUP_FOLDER
fi

if [ -f $LIGHTDMRC_FILE ]
then
    if [ -f $LIGHTDMRC_LOCATION ]
    then
        echo "LIGHTDM configuration file detected: Backing up to $BACKUP_FOLDER"
        sudo mv $LIGHTDMRC_LOCATION $BACKUP_FOLDER/
    fi
    sudo ln -f -s $LIGHTDMRC_FILE $LIGHTDMRC_LOCATION
fi

if [ -f $LIGHTDM_GREETER_RC_FILE ]
then
    if [ -f $LIGHTDM_GREETER_RC_LOCATION ]
    then
        echo "LIGHTDM configuration file detected: Backing up to $BACKUP_FOLDER"
        sudo mv $LIGHTDM_GREETER_RC_LOCATION $BACKUP_FOLDER/
    fi
    sudo ln -f -s $LIGHTDM_GREETER_RC_FILE $LIGHTDM_GREETER_RC_LOCATION
fi
