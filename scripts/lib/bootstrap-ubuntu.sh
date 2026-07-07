#!/usr/bin/env bash

set -ue

function bootstrap_ubuntu() {
  info_message "Install minimal bootstrap packages for Ubuntu."
  run_privileged apt-get update
  run_privileged apt-get install -y \
    ca-certificates \
    curl \
    git \
    passwd \
    sudo \
    xz-utils \
    zsh
  complete_message "Ubuntu bootstrap packages are installed."
}
