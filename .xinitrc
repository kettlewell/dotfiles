#!/usr/bin/env sh

# [[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

xrdb -load ${HOME}/.Xresources
