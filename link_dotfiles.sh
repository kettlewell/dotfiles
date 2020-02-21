#!/usr/bin/env bash

# For now, assume this script is run from static directory

dotfiles=($(ls -d ${HOME}/dotfiles/.[^#.]*))

for dotfile in ${dotfiles[@]}; do

    if [[ ! -d ${dotfile} ]]; then
	printf "unlinking ${dotfile}\n"
	rm  ${HOME}/${dotfile##*/}
    elif [[ -d ${dotfile} ]]; then
	printf "removing ${dotfile}\n"
	rm -r ${HOME}/${dotfile##*/}
    fi
    printf "Linking ${dotfile}\n"
    ln -s  ${dotfile} ${HOME}/${dotfile##*/}
done	    
