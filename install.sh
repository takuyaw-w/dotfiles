#!/usr/bin/env bash

set -ue

current_dir=$(dirname "${BASH_SOURCE[0]:-$0}")

source "$current_dir/scripts/lib/utilfuncs.sh"

print_warning "install.sh is a convenience wrapper."
print_default "For explicit setup, run:"
print_default "  ~/.dotfiles/dotfiles.sh doctor"
print_default "  ~/.dotfiles/dotfiles.sh bootstrap"
print_default "  ~/.dotfiles/dotfiles.sh gitconfig"
print_default "  ~/.dotfiles/dotfiles.sh switch"
print_default ""

"$current_dir/dotfiles.sh" install
