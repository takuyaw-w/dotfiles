#!/bin/env bash

source $(dirname "${BASH_SOURCE[0]:-$0}")/utilfuncs.sh

info_message "Start install AUR helper"

if ! builtin command -v paru >/dev/null 2>&1; then
  if [ ! -d /tmp/paru ]; then
    (cd /tmp && git clone https://aur.archlinux.org/paru.git)
  fi
  sudo pacman -S --noconfirm --needed base-devel
  (cd /tmp/paru && makepkg si --noconfirm && paru -Syy)
fi

complete_message "Install AUR helper done."
