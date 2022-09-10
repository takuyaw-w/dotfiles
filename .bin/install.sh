#!/usr/bin/env bash

set -ue

############
#   main   #
############
function main() {
  readonly CURRENT_DIR=$(dirname "${BASH_SOURCE[0]:-$0}")
  source $CURRENT_DIR/lib/utilfuncs.sh

  source $CURRENT_DIR/lib/link-to-homedir.sh
  source $CURRENT_DIR/lib/aur-helper.sh
  source $CURRENT_DIR/lib/install-packages.sh
  source $CURRENT_DIR/lib/gitconfig.sh
  source $CURRENT_DIR/lib/input-method.sh
  source $CURRENT_DIR/lib/install-fonts.sh
  source $CURRENT_DIR/lib/setup-terminal.sh
}

main "$@"
