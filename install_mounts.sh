#!/usr/bin/env bash

install_mount() {
  mount_point=$1
  mount_source=$2

  if [[ -z "$(mount | grep "${mount_point}")" ]]; then
    [[ -d ${mount_point} ]] || sudo mkdir ${verbose} -p ${mount_point}
    mount_options="credentials=${target_dir}/.credentials-usfornax,rw,iocharset=utf8,uid=$(id -u),gid=$(id -g),file_mode=0777,dir_mode=0777"
    if [[ -n "$(ls -A ${mount_point})" ]]; then
      echo "WARN: ${mount_point} exists and is non-empty. Edit /etc/fstab with a different mount point, remove \'noauto\', and \'sudo mount ${mount_point}\'."
      mount_options="${mount_options},noauto"
    fi
    if [[ -z "$(grep "${mount_source}" /etc/fstab)" ]]; then
      sudo sh ${verbose} -c "echo \"${mount_source} ${mount_point} cifs ${mount_options} 0 0\" >> /etc/fstab"
    else
      verbose "/etc/fstab already contains ${mount_source}."
    fi
    [[ $mount_options =~ .*noauto.* ]] || sudo mount ${verbose} ${mount_point}
  else
    verbose "${mount_point} already mounted."
  fi
}

install_mounts() {
  # mount EIM share
  install_mount "${eim_mount_point}" '//fs-gps-ocx-eim.usfornax.ifornax.ray.com/c$/GPS_OCX_EIM_export'
  # mount IFDC dropbox
  install_mount "${dropbox_aur_mount_point}" '//aur-forfile01.usfornax.ifornax.ray.com/dropbox'
}

## Source Check
if [[ "${BASH_SOURCE}" == "$0" ]]; then
  source vars.sh
  source main_common.sh
  install_mounts "$@"
fi
