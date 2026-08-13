#!/bin/bash

BASEDIR=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
BACKUP_FOLDER="$HOME/.dotfiles_backup"

NVIM_INIT_LUA="$BASEDIR/config/init.lua"
NVIM_LOCATION="$HOME/.config/nvim/init.lua"

if ! [ -d $BACKUP_FOLDER ]
then
    mkdir $BACKUP_FOLDER
fi
if [ -f $NVIM_INIT_LUA ]
    then
    if [ -f $NVIM_LOCATION ]
    then
        echo "nvim configuration file detected: Backing up to $BACKUP_FOLDER"
        mv $NVIM_LOCATION $BACKUP_FOLDER/
    fi
    ln -f -s $NVIM_INIT_LUA $NVIM_LOCATION
fi

