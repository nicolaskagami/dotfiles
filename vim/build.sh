#!/bin/bash
# Nicolas Silveira Kagami
# VIM builder

BASEDIR=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
BACKUP_FOLDER="$HOME/.dotfiles_backup"

VIMRC_FILE="$BASEDIR/vimrc"
VIMRC_LOCATION="$HOME/.vimrc"

VIM_COLOR_FOLDER="$BASEDIR/colors"
VIM_COLOR_FOLDER_LOCATION="$HOME/.vim/colors"

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
    sudo ln -f -s $VIMRC_FILE $VIMRC_LOCATION
fi

mkdir $HOME/.vim
sudo ln -f -s $VIM_COLOR_FOLDER $VIM_COLOR_FOLDER_LOCATION

git clone https://github.com/gmarik/Vundle.vim ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

curl http://www.vim.org/scripts/download_script.php?src_id=19588 > clang_complete.vmb
vim clang_complete.vmb -c 'so %' -c 'q'


#cd $VIM_COLOR_FOLDER
#mkdir tags
#curl https://vim.sourceforge.io/scripts/download_script.php?src_id=9178 > cpp_src.tar.bz2
#tar jxf cpp_src.tar.bz2
#ctags -R --sort=1 --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++ -f cpp cpp_src
#ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++ -f sdl /usr/include/SDL2/ # for SDL
#mv cpp ./tags/
#mv sdl ./tags/
