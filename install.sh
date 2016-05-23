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

  # Install fonts
  [[ -d ~/.local/share ]] || mkdir -p ~/.local/share
  rsync -a fonts ~/.local/share/
  fc-cache -fv
}

## Source Check
[[ "${BASH_SOURCE}" == "$0" ]] && main "$@"
