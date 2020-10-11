#!/bin/env bash

source $(dirname "${BASH_SOURCE[0]:-$0}")/utilfuncs.sh

info_message "Start git configuration."

readonly GIT_CONFIG_LOCAL=$HOME/.gitconfig.local
if [ ! -e $GIT_CONFIG_LOCAL ]; then
	print_notice -n "( =_=)...git config user.email please.> "
	read GIT_AUTHOR_EMAIL

	print_notice -n "( =_=)...git config user.name please.> "
	read GIT_AUTHOR_NAME

	cat << GITCONFIG > $GIT_CONFIG_LOCAL
[user]
    name = $GIT_AUTHOR_NAME
    email = $GIT_AUTHOR_EMAIL
GITCONFIG
fi

complete_message "git configuration is done."
