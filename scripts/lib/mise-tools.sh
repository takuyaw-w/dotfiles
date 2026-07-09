#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]:-$0}")/nix-home-manager.sh"

function find_mise_command() {
  if builtin command -v mise >/dev/null 2>&1; then
    command -v mise
    return 0
  fi

  if [[ -x "$HOME/.nix-profile/bin/mise" ]]; then
    echo "$HOME/.nix-profile/bin/mise"
    return 0
  fi

  return 1
}

function install_mise_tools() {
  if [[ "${DOTFILES_SKIP_MISE:-}" == "1" ]]; then
    print_warning "Skip mise install because DOTFILES_SKIP_MISE=1."
    return 0
  fi

  if [[ "${DOTFILES_SKIP_HOME_MANAGER:-}" == "1" ]]; then
    print_warning "Skip mise install because DOTFILES_SKIP_HOME_MANAGER=1."
    return 0
  fi

  load_nix_profile

  local mise_command
  if ! mise_command=$(find_mise_command); then
    print_warning "mise command is not available."
    print_default "Run Home Manager switch first, then rerun:"
    print_default "  ~/.dotfiles/dotfiles.sh mise"
    return 1
  fi

  info_message "Install mise-managed tools."
  "$mise_command" install || return $?
  complete_message "mise-managed tools are installed."
}
