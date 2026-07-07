#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]:-$0}")/utilfuncs.sh"

info_message "Start git configuration."

readonly GIT_CONFIG_LOCAL="$HOME/.gitconfig.local"
if [[ ! -e "$GIT_CONFIG_LOCAL" ]]; then
	print_warning "Git user.name / user.email are not configured."
	print_default "Create ~/.gitconfig.local on this machine."
	print_default "Example:"
	print_default "[user]"
	print_default "    name = Your Name"
	print_default "    email = you@example.com"
fi

complete_message "git configuration is done."
