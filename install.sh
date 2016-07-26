#!/usr/bin/env bash
# install.sh
# Installs base env
# John R. Ray <john@johnray.io>
# set -x
#

## Variables

## Functions
main() {
  target_dir="$(readlink -f ~)"
  # Copy dotfiles
  for file in $(ls dotfiles); do
    cp dotfiles/${file} ${target_dir}/.${file}
  done
  
  bash_aliases="$(cat ${target_dir}/.bash_aliases)"
  read -p "Enter your email address: " email
  name="$(getent passwd $USER | cut -d ':' -f 5)"
  echo "export USER_FULL_NAME=\"$name\"" > ${target_dir}/.bash_aliases
  echo "export EMAIL=\"$email\"" >> ${target_dir}/.bash_aliases
  echo "$bash_aliases" >> ${target_dir}/.bash_aliases

  echo "  name = $name" >> ${target_dir}/.gitconfig
  echo "  email = $email" >> ${target_dir}/.gitconfig

  # Copy directories
  for dir in ssh berkshelf vim chef; do
    rsync -a ${dir}/ ${target_dir}/.${dir}
  done
  rsync -a bin/ ${target_dir}/bin

  [[ -e ${target_dir}/.ssh/id_rsa ]] || ssh-keygen -b 2048 -t rsa -f ${target_dir}/.ssh/id_rsa -q -N ""

  # Copy vim plugins
  tar xf plugins.tar -C ${target_dir}/.vim/bundle/
  
  # Copy chef stuff
  tar xf chef.tar -C ${target_dir}/.chef

  # Install fonts
  [[ -d ${target_dir}/.local/share ]] || mkdir -p ${target_dir}/.local/share
  rsync -a fonts ${target_dir}/.local/share
  [[ -h ${target_dir}/.fonts ]] || ln -s  ${target_dir}/.local/share/fonts/ ${target_dir}/.fonts
  fc-cache -fv

  # Update Git
  for dir in foodcritic code_generator bootstrap; do
    cd ${target_dir}/.chef/${dir}
    git pull
  done

  # Create dev directory structure if it doesn't already exist
  [[ -d ${target_dir}/dev/chef/cookbooks ]] || mkdir -p ${target_dir}/dev/chef/cookbooks
  
  # mount EIM share
  if [[ -z "$(mount | grep '//fs-gps-ocx-eim.usfornax.ifornax.ray.com/c$/GPS_OCX_EIM_export')" ]]; then
    [[ -d /share ]] || sudo mkdir /share
    if [[ ! -e ${target_dir}/.credentials-usfornax ]]; then
      read -s -p "Enter your usfornax password: " pass
      echo "username=usfornax/${USER}" > ${target_dir}/.credentials-usfornax
      echo "password=${pass}" >> ${target_dir}/.credentials-usfornax
    fi
    chmod 600 ${target_dir}/.credentials-usfornax
    [[ -n "$(grep '//fs-gps-ocx-eim.usfornax.ifornax.ray.com/c$/GPS_OCX_EIM_export' /etc/fstab)" ]] || sudo sh -c "echo \"//fs-gps-ocx-eim.usfornax.ifornax.ray.com/c$/GPS_OCX_EIM_export /share cifs credentials=${target_dir}/.credentials-usfornax,rw,iocharset=utf8,uid=$(id -u),gid=$(id -g),file_mode=0777,dir_mode=0777 0 0\" >> /etc/fstab"
    sudo mount /share
  fi

  # install ChefDK
  sudo yum localinstall /share/chefdk-0.13.21-1.el6.x86_64.rpm
}
## Source Check
[[ "${BASH_SOURCE}" == "$0" ]] && main "$@"
