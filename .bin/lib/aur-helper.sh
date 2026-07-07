#!/usr/bin/env bash

set -ue

CURRENT_DIR=$(dirname "${BASH_SOURCE[0]:-$0}")
source "$CURRENT_DIR/utilfuncs.sh"
source "$CURRENT_DIR/os-release.sh"

function install_aur_helper() {
  local distro
  distro=$(detect_distro_family)

  if [[ "$distro" != "arch" ]]; then
    print_warning "AUR helper is only supported on Arch/Manjaro."
    return 0
  fi

  info_message "Start install AUR helper."

  if ! builtin command -v paru >/dev/null 2>&1; then
    if [[ ! -d /tmp/paru-bin ]]; then
      git clone https://aur.archlinux.org/paru-bin.git /tmp/paru-bin
    fi
    sudo pacman -S --noconfirm --needed base-devel
    (cd /tmp/paru-bin && makepkg -sif --noconfirm && paru -Syy)
  fi

  complete_message "Install AUR helper done."
}
