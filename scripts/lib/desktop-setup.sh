#!/usr/bin/env bash

set -ue

CURRENT_DIR=$(dirname "${BASH_SOURCE[0]:-$0}")
source "$CURRENT_DIR/utilfuncs.sh"

print_warning "Desktop setup installs OS-integrated packages and changes user desktop settings."
print_default "Chrome and VS Code are intentionally not installed through Nix."
print_default "Install Chrome and VS Code with each distro's official package flow."
print_default ""

source "$CURRENT_DIR/input-method.sh"
install_input_method

source "$CURRENT_DIR/install-fonts.sh"
install_fonts

mkdir -p "$HOME/.config"

if builtin command -v google-chrome >/dev/null 2>&1 && builtin command -v xdg-mime >/dev/null 2>&1; then
  xdg-mime default google-chrome.desktop x-scheme-handler/http
  xdg-mime default google-chrome.desktop x-scheme-handler/https
fi

complete_message "Desktop setup is done."
