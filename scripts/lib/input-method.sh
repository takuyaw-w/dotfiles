#!/usr/bin/env bash

set -ue

CURRENT_DIR=$(dirname "${BASH_SOURCE[0]:-$0}")
source "$CURRENT_DIR/utilfuncs.sh"
source "$CURRENT_DIR/os-release.sh"

function configure_xprofile_fcitx() {
  local xprofile="$HOME/.xprofile"
  touch "$xprofile"

  local required_lines=(
    'export LANG="ja_JP.UTF-8"'
    'export XMODIFIERS="@im=fcitx"'
    'export XMODIFIER="@im=fcitx"'
    'export GTK_IM_MODULE=fcitx'
    'export QT_IM_MODULE=fcitx'
    'export DefaultIMModule=fcitx'
    'export GLFW_IM_MODULE=ibus'
  )
  local line

  for line in "${required_lines[@]}"; do
    grep -qxF "$line" "$xprofile" || printf '%s\n' "$line" >> "$xprofile"
  done
}

function install_input_method() {
  local distro
  distro=$(detect_distro_family)

  info_message "Install and configure Japanese input method."

  case "$distro" in
    arch)
      sudo pacman -S --noconfirm --needed fcitx5-im fcitx5-mozc
      ;;
    ubuntu)
      sudo apt-get update
      sudo apt-get install -y fcitx5 fcitx5-mozc
      ;;
    fedora)
      sudo dnf install -y fcitx5 fcitx5-mozc
      ;;
  esac

  configure_xprofile_fcitx
  complete_message "Input method setup is done."
}
