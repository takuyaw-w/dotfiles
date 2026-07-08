#!/usr/bin/env bash

set -ue

CURRENT_DIR=$(dirname "${BASH_SOURCE[0]:-$0}")
source "$CURRENT_DIR/utilfuncs.sh"
source "$CURRENT_DIR/os-release.sh"

function install_fonts() {
  local distro
  distro=$(detect_distro_family)

  info_message "Install desktop fonts."

  case "$distro" in
    arch)
      source "$CURRENT_DIR/aur-helper.sh"
      install_aur_helper
      paru -S --noconfirm --needed noto-fonts-cjk otf-source-han-code-jp ttf-cica ttf-ricty-diminished
      ;;
    ubuntu)
      sudo apt-get update
      sudo apt-get install -y fonts-noto-cjk fonts-noto-cjk-extra
      ;;
    fedora)
      sudo dnf install -y google-noto-sans-cjk-fonts google-noto-sans-mono-cjk-vf-fonts google-noto-serif-cjk-fonts
      ;;
  esac

  complete_message "Font setup is done."
}
