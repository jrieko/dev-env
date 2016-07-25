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
  
  bash_aliases="$(cat ~/.bash_aliases)"
  echo "Enter your email address:"
  read -p "Enter your email address: " email
  echo "export EMAIL=$email" > ~/.bash_aliases
  echo "$bash_aliases" >> ~/.bash_aliases

  name="$(getent passwd $USER | cut -d ':' -f 5)"
  echo "  name = $name" >> ~/.gitconfig
  echo "  email = $EMAIL" >> ~/.gitconfig

  # Copy directories
  for dir in ssh berkshelf vim chef; do
    rsync -a ${dir}/ ~/.${dir}
  done
  rsync -a bin/ ~/bin

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

  # Create dev directory structure if it doesn't already exist
  [[ -d ~/dev/chef/cookbooks ]] || mkdir -p ~/dev/chef/cookbooks

}
## Source Check
[[ "${BASH_SOURCE}" == "$0" ]] && main "$@"
