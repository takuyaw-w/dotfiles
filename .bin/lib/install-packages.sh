#!/usr/bin/env bash

source $(dirname "${BASH_SOURCE[0]:-$0}")/utilfuncs.sh

info_message "Start install the packages."

# for pacman
sudo pacman -S --noconfirm --needed zsh
sudo pacman -S --noconfirm --needed git
sudo pacman -S --noconfirm --needed vim
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
sudo pacman -S --noconfirm --needed nvm
sudo pacman -S --noconfirm --needed chromium
sudo pacman -S --noconfirm --needed docker
sudo pacman -S --noconfirm --needed rustup
sudo pacman -S --noconfirm --needed clang
sudo pacman -S --noconfirm --needed gcc
sudo pacman -S --noconfirm --needed gdb
sudo pacman -S --noconfirm --needed make
sudo pacman -S --noconfirm --needed cmake
sudo pacman -S --noconfirm --needed docker
sudo pacman -S --noconfirm --needed exa
sudo pacman -S --noconfirm --needed bat
sudo pacman -S --noconfirm --needed ripgrep
sudo pacman -S --noconfirm --needed go
sudo pacman -S --noconfirm --needed fzf
sudo pacman -S --noconfirm --needed yay

# for rust
rustup install stable
rustup component add rust-analysis rust-src rustfmt clippy

# for yay
yay -S --noconfirm --needed ghq
yay -S --noconfirm --needed visual-studio-code-bin

complete_message "Install packages done."
