#!/usr/bin/env bash

set -ue

current_dir=$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd -P)
lib_dir="$current_dir/scripts/lib"

source "$lib_dir/utilfuncs.sh"

function usage() {
  cat <<'USAGE'
Usage: dotfiles.sh <command>

Commands:
  doctor     Check distro, git identity, and Nix/Home Manager availability
  bootstrap  Install minimal distro packages
  gitconfig  Check ~/.gitconfig.local
  switch     Switch Home Manager profile
  mise       Install mise-managed tools
  install    Run bootstrap, gitconfig, switch, and mise
  desktop    Run desktop-specific setup
  update     Update flake.lock and run nix flake check
  help       Show this help
USAGE
}

function dotfiles_doctor() {
  source "$lib_dir/os-release.sh"
  source "$lib_dir/nix-home-manager.sh"

  local distro
  local git_identity_missing=0
  local home_manager_missing=0
  local nix_missing=0
  distro=$(detect_distro_family)
  print_default "Distro family: $distro"

  if [[ -e "$HOME/.gitconfig.local" ]]; then
    print_default "Git identity: configured by ~/.gitconfig.local"
  else
    print_warning "Git identity: missing ~/.gitconfig.local"
    git_identity_missing=1
  fi

  if builtin command -v nix >/dev/null 2>&1 || nix_profile_script >/dev/null 2>&1; then
    print_default "Nix: available or installed profile detected"
  else
    print_warning "Nix: not found"
    nix_missing=1
  fi

  if builtin command -v home-manager >/dev/null 2>&1; then
    print_default "Home Manager: available"
  else
    print_warning "Home Manager: not found"
    home_manager_missing=1
  fi

  if ((git_identity_missing || nix_missing || home_manager_missing)); then
    print_default ""
    print_default "Next steps:"
  fi

  if ((git_identity_missing)); then
    print_default "  Create ~/.gitconfig.local on this machine."
  fi

  if ((nix_missing)); then
    print_default "  sh <(curl -L https://nixos.org/nix/install) --daemon"
  fi

  if ((home_manager_missing)); then
    print_default "  nix profile install github:nix-community/home-manager"
  fi

  if ((git_identity_missing || nix_missing || home_manager_missing)); then
    print_default "  ~/.dotfiles/dotfiles.sh install"
  fi
}

function dotfiles_bootstrap() {
  source "$lib_dir/bootstrap.sh"
  run_bootstrap
}

function dotfiles_gitconfig() {
  source "$lib_dir/gitconfig.sh"
}

function dotfiles_switch() {
  source "$lib_dir/nix-home-manager.sh"
  switch_home_manager
}

function dotfiles_mise() {
  source "$lib_dir/mise-tools.sh"
  install_mise_tools
}

function print_desktop_hint() {
  print_default ""
  print_default "Desktop-specific setup is intentionally separate."
  print_default "Run ~/.dotfiles/dotfiles.sh desktop for desktop package and setting setup."
}

function dotfiles_install() {
  dotfiles_bootstrap
  dotfiles_gitconfig
  dotfiles_switch
  dotfiles_mise
  print_desktop_hint
}

function dotfiles_desktop() {
  "$lib_dir/desktop-setup.sh"
}

function dotfiles_update() {
  source "$lib_dir/flake-update.sh"
  update_flake_lock
}

case "${1:-help}" in
  doctor)
    dotfiles_doctor
    ;;
  bootstrap)
    dotfiles_bootstrap
    ;;
  gitconfig)
    dotfiles_gitconfig
    ;;
  switch)
    dotfiles_switch
    ;;
  mise)
    dotfiles_mise
    ;;
  install|apply)
    dotfiles_install
    ;;
  desktop)
    dotfiles_desktop
    ;;
  update)
    dotfiles_update
    ;;
  help|-h|--help)
    usage
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac
