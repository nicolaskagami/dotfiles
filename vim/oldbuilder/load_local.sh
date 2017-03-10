#!/bin/bash
# Nicolas Silveira Kagami

BASEDIR=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

VIMRC_FILE="$BASEDIR/vimrc"
VIM_FOLDER="$BASEDIR/vimfolder"


cp ~/.vimrc $VIMRC_FILE
