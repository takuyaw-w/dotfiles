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
  install    Run bootstrap, gitconfig, and switch
  desktop    Run desktop-specific setup
  help       Show this help
USAGE
}

function dotfiles_doctor() {
  source "$lib_dir/os-release.sh"
  source "$lib_dir/nix-home-manager.sh"

  local distro
  distro=$(detect_distro_family)
  print_default "Distro family: $distro"

  if [[ -e "$HOME/.gitconfig.local" ]]; then
    print_default "Git identity: configured by ~/.gitconfig.local"
  else
    print_warning "Git identity: missing ~/.gitconfig.local"
  fi

  if builtin command -v nix >/dev/null 2>&1 || nix_profile_script >/dev/null 2>&1; then
    print_default "Nix: available or installed profile detected"
  else
    print_warning "Nix: not found"
  fi

  if builtin command -v home-manager >/dev/null 2>&1; then
    print_default "Home Manager: available"
  else
    print_warning "Home Manager: not found"
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

function print_desktop_hint() {
  print_default ""
  print_default "Desktop-specific setup is intentionally separate."
  print_default "Run ~/.dotfiles/dotfiles.sh desktop for desktop package and setting setup."
}

function dotfiles_install() {
  dotfiles_bootstrap
  dotfiles_gitconfig
  dotfiles_switch
  print_desktop_hint
}

function dotfiles_desktop() {
  "$lib_dir/desktop-setup.sh"
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
  install|apply)
    dotfiles_install
    ;;
  desktop)
    dotfiles_desktop
    ;;
  help|-h|--help)
    usage
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac
