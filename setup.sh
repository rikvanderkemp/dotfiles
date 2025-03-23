#!/usr/bin/env sh

echo "Checking for Emacs directory ..."

if [ -d ~/.emacs.d/  ]; then
   echo "Emacs directory already exists. Aborting"
else
   echo "Not found, installing doom emacs"
   git clone --depth 1 --single-branch https://github.com/doomemacs/doomemacs ~/.emacs.d
fi

echo "Checking for DOOM Configuration"

if [ -d ~/.config/doom/ ]; then
    echo "Doom configuration already there, aborting..."
else
    echo "Installing config files"
    mkdir -p ~/.config/doom/
    cp ./doom/* ~/.config/doom/

    ~/.emacs.d/bin/doom install
fi
