#!/usr/bin/env bash

set -ue

############
#   main   #
############
function main() {
  local current_dir
  current_dir=$(dirname "${BASH_SOURCE[0]:-$0}")

  source "$current_dir/lib/utilfuncs.sh"

  source "$current_dir/lib/link-to-homedir.sh"
  source "$current_dir/lib/bootstrap.sh"
  run_bootstrap

  source "$current_dir/lib/gitconfig.sh"

  source "$current_dir/lib/nix-home-manager.sh"
  switch_home_manager

  print_default ""
  print_default "Desktop-specific setup is intentionally separate."
  print_default "Run ~/.dotfiles/.bin/lib/desktop-setup.sh for desktop package and setting setup."
}

main "$@"
