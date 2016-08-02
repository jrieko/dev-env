#!/usr/bin/env bash

install_home() {
  # dirty idempotency
  done_file="${target_settings_dir}/.install_home.done"

  if [[ ! -e ${done_file} ]]; then
    # Copy dotfiles
    for file in $(ls dotfiles); do
      cp ${verbose} dotfiles/${file} ${target_dir}/.${file}
    done
  else
    verbose "dotfiles already exist."
  fi
  
  bash_aliases="$(cat ${target_dir}/.bash_aliases)"
  echo -n "" > ${target_dir}/.bash_aliases
  if [[ -z "$(echo "$bash_aliases" | grep 'EMAIL=')" ]]; then
    read -p "Enter your email address: " email
    echo "export EMAIL=\"$email\"" >> ${target_dir}/.bash_aliases
  else
    verbose "${target_dir}/.bash_aliases already defines EMAIL."
  fi
  if [[ -z "$(echo "$bash_aliases" | grep 'USER_FULL_NAME=')" ]]; then
    name="$(getent passwd $USER | cut -d ':' -f 5)"
    echo "export USER_FULL_NAME=\"$name\"" >> ${target_dir}/.bash_aliases
  else
    verbose "${target_dir}/.bash_aliases already defines USER_FULL_NAME."
  fi
  echo "$bash_aliases" >> ${target_dir}/.bash_aliases
  source ${target_dir}/.bash_aliases

  [[ -n "$(git config -f ${target_dir}/.gitconfig user.name)" ]] || git config -f ${target_dir}/.gitconfig user.name "$USER_FULL_NAME"
  [[ -n "$(git config -f ${target_dir}/.gitconfig user.email)" ]] || git config -f ${target_dir}/.gitconfig user.name "$EMAIL"

  if [[ ! -e ${done_file} ]]; then
    # Copy directories
    for dir in ssh berkshelf vim chef; do
      rsync ${verbose} -a ${dir}/ ${target_dir}/.${dir}
    done
  else
    verbose "dotdirs already exist."
  fi
  rsync ${verbose} -a --ignore-existing bin/ ${target_dir}/bin

  [[ -e ${target_dir}/.ssh/id_rsa ]] || ssh-keygen -b 2048 -t rsa -f ${target_dir}/.ssh/id_rsa -q -N ""

  if [[ ! -e ${done_file} ]]; then
    # Copy vim plugins
    tar ${verbose} -xf plugins.tar -C ${target_dir}/.vim/bundle/
    
    # Copy chef stuff
    tar ${verbose} -xf chef.tar -C ${target_dir}/.chef

    # Install fonts
    [[ -d ${target_dir}/.local/share ]] || mkdir ${verbose} -p ${target_dir}/.local/share
    rsync ${verbose} -a fonts ${target_dir}/.local/share
    [[ -h ${target_dir}/.fonts ]] || ln ${verbose} -s  ${target_dir}/.local/share/fonts/ ${target_dir}/.fonts
    fc-cache -f ${verbose}
  else
    verbose "other stuff already exists"
  fi

  # Update Git
  for dir in foodcritic code_generator bootstrap; do
    cd ${target_dir}/.chef/${dir}
    git pull
  done

  # Create dev directory structure if it doesn't already exist
  [[ -d ${dev_chef_dir}/cookbooks ]] || mkdir ${verbose} -p ${dev_chef_dir}/cookbooks

  if [[ ! -e ${target_dir}/.credentials-usfornax ]]; then
    read -s -p "Enter your usfornax (IFDC) password: " pass
    echo "username=usfornax/${USER}" > ${target_dir}/.credentials-usfornax
    echo "password=${pass}" >> ${target_dir}/.credentials-usfornax
  else
    verbose "${target_dir}/.credentials-usfornax already exists."
  fi
  chmod 600 ${target_dir}/.credentials-usfornax

  touch $done_file
}

## Source Check
if [[ "${BASH_SOURCE}" == "$0" ]]; then
  source vars.sh
  source main_common.sh
  install_home "$@"
fi
