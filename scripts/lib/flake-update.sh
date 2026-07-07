#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]:-$0}")/utilfuncs.sh"

function update_flake_lock() {
  if ! builtin command -v nix >/dev/null 2>&1; then
    print_warning "nix command is not available."
    print_default "Install or load Nix, then rerun:"
    print_default "  ~/.dotfiles/dotfiles.sh update"
    return 1
  fi

  local dotfiles_dir

  dotfiles_dir=$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")/../.." && pwd -P)

  info_message "Update flake.lock"
  nix flake update --flake "$dotfiles_dir" || return $?

  info_message "Run nix flake check"
  nix flake check "$dotfiles_dir" || return $?

  complete_message "flake.lock update is done."
}
