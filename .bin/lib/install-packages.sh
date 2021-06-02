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
sudo pacman -S --noconfirm --needed rustup
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
sudo pacmna -S --noconfirm --needed deno
sudo pacman -S --noconfirm --needed github-cli
sudo pacman -S --noconfirm --needed alacritty

# for rust
rustup install stable
rustup component add rust-analysis rust-src rustfmt clippy

# for paru
paru -S --noconfirm --needed ghq-bin
paru -S --noconfirm --needed visual-studio-code-bin
paru -S --noconfirm --needed gitui
paru -S --noconfirm --needed git-delta-git
paru -S --noconfirm --needed boost-note-bin
paru -S --noconfirm --needed google-chrome
paru -S --noconfirm --needed volta
paru -S --noconfirm --needed ranger

# for volta
volta install node@latest
volta install yarn
volta install @vue/cli
volta install neovim

# default settings
xdg-mime default google-chrome.desktop x-scheme-handler/http
xdg-mime default google-chrome.desktop x-scheme-handler/https

complete_message "Install packages done."
