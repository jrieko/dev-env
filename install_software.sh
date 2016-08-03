#!/usr/bin/env bash

rpm_package() {
  sudo yum list installed $1 || sudo yum ${verbose} localinstall -y ${eim_mount_point}/$1.rpm
}

gem_package() {
  gem list $1 -i --silent || gem install ${verbose} -s http://rubygems.org --no-rdoc --no-ri $1
}

install_software() {
  # install ChefDK
  if [[ -d ${eim_mount_point} && -n "$(ls -A ${eim_mount_point})" ]]; then
    if [[ "$(lsb_release -rs)" =~ 6\.[0-9.]+ ]]; then
      for p in ${yum_install_rhel6[@]}; do
        rpm_package $p
      done
    elif [[ "$(lsb_release -rs)" =~ 7\.[0-9.]+ ]]; then
      for p in ${yum_install_rhel7[@]}; do
        rpm_package $p
      done
    else
      echo 'WARN: Unknown OS. Not installing ChefDK.'
    fi
  else
    echo "WARN: ${eim_mount_point} not mounted. Not installing ChefDK."
  fi

  for p in ${gem_install[@]}; do
    gem_package $p
  done
}

## Source Check
if [[ "${BASH_SOURCE}" == "$0" ]]; then
  source vars.sh
  source main_common.sh
  proxyon
  install_software "$@"
fi
