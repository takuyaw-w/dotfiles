#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]:-$0}")/utilfuncs.sh"

function nix_profile_script() {
  local profile="$HOME/.nix-profile/etc/profile.d/nix.sh"
  local daemon="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"

  if [[ -r "$profile" ]]; then
    echo "$profile"
    return 0
  fi

  if [[ -r "$daemon" ]]; then
    echo "$daemon"
    return 0
  fi

  return 1
}

function load_nix_profile() {
  local profile_script

  if profile_script=$(nix_profile_script); then
    # shellcheck source=/dev/null
    source "$profile_script"
  fi
}

function print_nix_install_hint() {
  print_warning "Nix is not installed or not loaded in PATH."
  print_default "Install Nix explicitly, then rerun this installer:"
  print_default "  sh <(curl -L https://nixos.org/nix/install) --daemon"
  print_default ""
  print_default "This installer does not install Nix unless a future explicit option is added."
}

function home_manager_target() {
  local system

  system=$(nix eval --impure --raw --expr 'builtins.currentSystem')
  echo "takuya-${system}"
}

function switch_home_manager() {
  if [[ "${DOTFILES_SKIP_HOME_MANAGER:-}" == "1" ]]; then
    print_warning "Skip Home Manager switch because DOTFILES_SKIP_HOME_MANAGER=1."
    return 0
  fi

  load_nix_profile

  if ! builtin command -v nix >/dev/null 2>&1; then
    print_nix_install_hint
    return 1
  fi

  if ! builtin command -v home-manager >/dev/null 2>&1; then
    print_warning "home-manager command is not installed."
    print_default "Run this command once, then rerun the installer:"
    print_default "  nix profile install github:nix-community/home-manager"
    return 1
  fi

  local dotfiles_dir
  local target

  dotfiles_dir=$(git -C "$(dirname "${BASH_SOURCE[0]:-$0}")" rev-parse --show-toplevel)
  target=$(home_manager_target)

  info_message "Switch Home Manager profile: ${target}"
  home-manager switch --flake "${dotfiles_dir}#${target}" || return $?
  complete_message "Home Manager switch is done."
}
