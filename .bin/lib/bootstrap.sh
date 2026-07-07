#!/usr/bin/env bash

set -ue

source "$(dirname "${BASH_SOURCE[0]:-$0}")/utilfuncs.sh"
source "$(dirname "${BASH_SOURCE[0]:-$0}")/os-release.sh"

function run_bootstrap() {
  local bootstrap_dir
  local distro

  bootstrap_dir=$(dirname "${BASH_SOURCE[0]:-$0}")
  distro=$(detect_distro_family)

  case "$distro" in
    arch)
      source "$bootstrap_dir/bootstrap-arch.sh"
      bootstrap_arch
      ;;
    ubuntu)
      source "$bootstrap_dir/bootstrap-ubuntu.sh"
      bootstrap_ubuntu
      ;;
    fedora)
      source "$bootstrap_dir/bootstrap-fedora.sh"
      bootstrap_fedora
      ;;
    *)
      print_error "Unsupported bootstrap target: $distro"
      return 1
      ;;
  esac
}
