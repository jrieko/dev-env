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
  [[ -n "$(git config -f ${target_dir}/.gitconfig user.email)" ]] || git config -f ${target_dir}/.gitconfig user.email "$EMAIL"

  if [[ ! -e ${done_file} ]]; then
    # Copy directories
    for dir in ssh berkshelf vim chef; do
      rsync ${verbose} -a ${dir}/ ${target_dir}/.${dir}
    done
  else
    verbose "dotdirs already exist."
  fi
  rsync ${verbose} -a --ignore-existing bin/ ${target_dir}/bin

  # credentials for nas mounts
  if [[ ! -e ${target_dir}/.credentials-usfornax ]]; then
    read -s -p "Enter your usfornax (IFDC) password: " pass
    echo "username=usfornax/${USER}" > ${target_dir}/.credentials-usfornax
    echo "password=${pass}" >> ${target_dir}/.credentials-usfornax
  else
    verbose "${target_dir}/.credentials-usfornax already exists."
  fi
  chmod 600 ${target_dir}/.credentials-usfornax
  source ${target_dir}/.credentials-usfornax

  # ssh key
  [[ -e ${target_dir}/.ssh/id_rsa ]] || ssh-keygen -b 2048 -t rsa -f ${target_dir}/.ssh/id_rsa -q -N ""

  # add ssh key to gitlab
  gitlab_session="$(curl --silent ${verbose} http://gitlab-server/api/v3/session --data 'login='${USER}'&password='${password})"
  if [[ $gitlab_session =~ ^.*401' 'Unauthorized.*$ ]]; then
    echo "ERROR: Gitlab login failed. Email GPS_OCX_IFDC_HELP for support. [request='POST http://gitlab-server/api/v3/session?login=${USER}&password=(redacted)', response='${gitlab_session}']"
    exit 3
  elif [[ ! $gitlab_session =~ ^.*'"'private_token'"':'"'([^'"']+)'"'.*$ ]]; then
    echo "ERROR: no private token for user."
    exit 4
  fi
  
  gitlab_private_token="${BASH_REMATCH[1]}"
  verbose "gitlab_private_token='${gitlab_private_token}'"

  ssh_pubkey=( $(cat ${target_dir}/.ssh/id_rsa.pub) )

  if [[ -z "$(curl --silent ${verbose} -G 'http://gitlab-server/api/v3/user/keys?private_token='${gitlab_private_token} | grep ${ssh_pubkey[1]})" ]]; then
    curl ${verbose} -X POST -F "private_token=${gitlab_private_token}" -F "title=${ssh_pubkey[2]}" -F "key=${ssh_pubkey[*]}" "http://gitlab-server/api/v3/user/keys"
  else
    verbose "SSH key already added to GitLab."
  fi


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


  touch $done_file
}

## Source Check
if [[ "${BASH_SOURCE}" == "$0" ]]; then
  source vars.sh
  source main_common.sh
  install_home "$@"
fi
