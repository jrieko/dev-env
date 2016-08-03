#!/usr/bin/env bash
# install.sh
# Installs base env
# John R. Ray <john@johnray.io>
# set -x
#

## Variables
source install_home.sh
source install_mounts.sh
source install_software.sh

## Source Check
if [[ "${BASH_SOURCE}" == "$0" ]]; then
  source vars.sh
  source main_common.sh
  install_home "$@"
  proxyon
  install_mounts "$@"
  install_software "$@"
fi
