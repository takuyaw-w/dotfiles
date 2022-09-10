#!/usr/bin/env bash

source $(dirname "${BASH_SOURCE[0]:-$0}")/utilfuncs.sh

info_message "Start install the packages."

# for pacman
sudo pacman -S --noconfirm --needed zsh
sudo pacman -S --noconfirm --needed git
sudo pacman -S --noconfirm --needed neovim
sudo pacman -S --noconfirm --needed tmux
sudo pacman -S --noconfirm --needed ctags
sudo pacman -S --noconfirm --needed bc
sudo pacman -S --noconfirm --needed curl
sudo pacman -S --noconfirm --needed wget
sudo pacman -S --noconfirm --needed xsel
sudo pacman -S --noconfirm --needed gawk
sudo pacman -S --noconfirm --needed python-pip
sudo pacman -S --noconfirm --needed unzip
sudo pacman -S --noconfirm --needed sqlite
sudo pacman -S --noconfirm --needed gettext
sudo pacman -S --noconfirm --needed procps
sudo pacman -S --noconfirm --needed jq
sudo pacman -S --noconfirm --needed docker
sudo pacman -S --noconfirm --needed docker-compose
sudo pacman -S --noconfirm --needed clang
sudo pacman -S --noconfirm --needed gcc
sudo pacman -S --noconfirm --needed gdb
sudo pacman -S --noconfirm --needed make
sudo pacman -S --noconfirm --needed cmake
sudo pacman -S --noconfirm --needed exa
sudo pacman -S --noconfirm --needed bat
sudo pacman -S --noconfirm --needed ripgrep
sudo pacman -S --noconfirm --needed fzf
sudo pacman -S --noconfirm --needed go
sudo pacman -S --noconfirm --needed deno
sudo pacman -S --noconfirm --needed github-cli
sudo pacman -S --noconfirm --needed alacritty
sudo pacman -S --noconfirm --needed wezterm
sudo pacman -S --noconfirm --needed rofi
sudo pacman -S --noconfirm --needed libsecret

# for paru
paru -S --noconfirm --needed ghq-bin
paru -S --noconfirm --needed visual-studio-code-bin
paru -S --noconfirm --needed gitui
paru -S --noconfirm --needed git-delta-git
paru -S --noconfirm --needed google-chrome
paru -S --noconfirm --needed fnm-bin
paru -S --noconfirm --needed ranger
paru -S --noconfirm --needed w3m
paru -S --noconfirm --needed gomi
paru -S --noconfirm --needed sysz

# default settings
xdg-mime default google-chrome.desktop x-scheme-handler/http
xdg-mime default google-chrome.desktop x-scheme-handler/https

complete_message "Install packages done."
