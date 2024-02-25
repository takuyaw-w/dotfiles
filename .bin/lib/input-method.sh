#!/usr/bin/env bash

source $(dirname "${BASH_SOURCE[0]:-$0}")/utilfuncs.sh

info_message "Install and configure the packages required for the input method."

sudo pacman -S --noconfirm --needed fcitx5-im fcitx5-mozc

complete_message "Package install and configuration is done."
