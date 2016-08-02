#!/usr/bin/env bash
export dry_run=false
export verbose=''

verbose() {
  [[ -n "${verbose}" ]] && echo "$@"
}

proxyon() {
  export http_proxy=http://proxy.usfornax.ifornax.ray.com:80
  export https_proxy=${http_proxy}
  export HTTP_PROXY=${http_proxy}
  export HTTPS_PROXY=${http_proxy}
  export no_proxy="localhost,127.0.0.1,.ray.com,10.0.0.0/8,192.168.0.0/16,gitlab-server,chef-server,jenkins-server"
}

usage() {
  echo "usage: $0 [OPTIONS]"
#  echo "  --dry-run            Print what would be done; don't modify anything."
  echo "  -v, --verbose"
  echo "  -h, --help           Display this help and exit."
}

#process common args
while [[ -n "$1" ]]; do
  case $1 in
    -v | --verbose )      export verbose='--verbose'
                          ;;
    --dry-run )           export dry_run=true
                          ;;
    -h | --help )         usage
                          exit
                          ;;
    * )                   break
  esac
  shift
done

