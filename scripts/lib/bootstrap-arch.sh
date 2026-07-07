#!/usr/bin/env bash

set -ue

function bootstrap_arch() {
  info_message "Install minimal bootstrap packages for Arch/Manjaro."
  run_privileged pacman -Syu --noconfirm --needed \
    ca-certificates \
    curl \
    git \
    shadow \
    sudo \
    xz \
    zsh
  complete_message "Arch/Manjaro bootstrap packages are installed."
}
