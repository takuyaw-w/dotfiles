#!/usr/bin/env bash

source $(dirname "${BASH_SOURCE[0]:-$0}")/utilfuncs.sh

info_message "Install and configure the packages required for the input method."

sudo pacman -S --noconfirm --needed fcitx-im fcitx-mozc

cat << EOF >> ~/.xprofile
export LANG="ja_JP.UTF-8"
export XMODIFIERS="@im=fcitx"
export XMODIFIER="@im=fcitx"
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export DefaultIMModule=fcitx
EOF

complete_message "Package install and configuration is done."
