#!/usr/bin/env bash

info_message "Set up the terminal."

chsh -s $(which zsh)

exec $SHELL -l

complete_message "The terminal settings are complete."
