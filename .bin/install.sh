#!/usr/bin/env bash

set -ue

function confirm() {
  local answer

  print_notice "( =_=)...Start install the dotfiles? [yes/no]"
  read -r answer
  case $answer in
    yes|y)
      return
      ;;
    no|n)
      print_warning "( =_=)...Ok. bye."
      exit 1
      ;;
    *)
      print_error "( @_@)...invalid value."
      exit 1
      ;;
  esac
}

############
#   main   #
############
function main() {
  readonly CURRENT_DIR=$(dirname "${BASH_SOURCE[0]:-$0}")
  source $CURRENT_DIR/lib/utilfuncs.sh

  confirm

  source $CURRENT_DIR/lib/link-to-homedir.sh
  source $CURRENT_DIR/lib/aur-helper.sh
  source $CURRENT_DIR/lib/install-packages.sh
  source $CURRENT_DIR/lib/gitconfig.sh
  source $CURRENT_DIR/lib/input-method.sh
  source $CURRENT_DIR/lib/install-fonts.sh
  source $CURRENT_DIR/lib/setup-terminal.sh
}

main "$@"
