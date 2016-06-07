#!/usr/bin/env bash
# install.sh
# Installs base env
# John R. Ray <john@johnray.io>
# set -x
#

## Variables

## Functions
main() {
  # Copy dotfiles
  for file in $(ls dotfiles); do
    cp dotfiles/${file} ~/.${file}
  done

  # Copy directories
  for dir in ssh berkshelf vim chef; do
    rsync -a ${dir}/ ~/.${dir}
  done

  # Copy vim plugins
  tar xf plugins.tar -C ~/.vim/bundle/
  
  # Copy chef stuff
  tar xf chef.tar -C ~/.chef

  # Install fonts
  [[ -d ~/.local/share ]] || mkdir -p ~/.local/share
  rsync -a fonts ~/.local/share
  [[ -h ~/.fonts ]] || ln -s  ~/.local/share/fonts/ ~/.fonts
  fc-cache -fv

  # Update Git
  for dir in foodcritic code_generator bootstrap; do
    cd ~/.chef/${dir}
    git pull
  done

}
## Source Check
[[ "${BASH_SOURCE}" == "$0" ]] && main "$@"
