#!/usr/bin/env sh

export target_dir="$(readlink -f ~)"
[[ -d ${target_dir} ]] || mkdir ${verbose} -p ${target_dir}
export target_settings_dir="${target_dir}/.local/share/dev-env"
[[ -d ${target_settings_dir} ]] || mkdir ${verbose} -p ${target_settings_dir}
export dev_chef_dir="${target_dir}/dev/chef"
export eim_mount_point='/share'
export dropbox_aur_mount_point='/mnt/dropbox-aur'
export yum_install_rhel6=(
  'chefdk-0.13.21-1.el6.x86_64'
  'libicu-4.2.1-14.el6.x86_64'
  'libicu-devel-4.2.1-14.el6.x86_64'
  )
export yum_install_rhel7=(
  'chefdk-0.13.21-1.el7.x86_64'
  )
export gem_install=(
  'gollum'
  )
