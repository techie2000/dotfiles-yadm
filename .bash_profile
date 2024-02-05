#!/bin/bash

echo "**** $HOME/.bash_profile **** starts ****"

if [ -f ~/.bashrc ];  then
        .  ~/.bashrc;
fi

PATH=$PATH:$HOME/bin export PATH

echo "**** $HOME/.bash_profile **** ends ****"

. "$HOME/.cargo/env"
