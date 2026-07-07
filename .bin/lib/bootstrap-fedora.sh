#!/usr/bin/env bash

set -ue

function bootstrap_fedora() {
  info_message "Install minimal bootstrap packages for Fedora."
  sudo dnf install -y \
    ca-certificates \
    curl \
    git \
    shadow-utils \
    sudo \
    xz \
    zsh
  complete_message "Fedora bootstrap packages are installed."
}
