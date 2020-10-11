#!/usr/bin/env bash

source $(dirname "${BASH_SOURCE[0]:-$0}")/utilfuncs.sh

info_message "Start install fonts."

yay -S --noconfirm --needed otf-source-han-code-jp
yay -S --noconfirm --needed ttf-cica
yay -S --noconfirm --needed ttf-ricty-diminished

complete_message "Install fonts is done."
