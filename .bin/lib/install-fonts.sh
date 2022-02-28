#!/usr/bin/env bash

source $(dirname "${BASH_SOURCE[0]:-$0}")/utilfuncs.sh

info_message "Start install fonts."

paru -S --noconfirm --needed otf-source-han-code-jp
paru -S --noconfirm --needed ttf-cica
paru -S --noconfirm --needed ttf-ricty-diminished

complete_message "Install fonts is done."
