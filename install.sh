#!bin/bash

# 初期設定
# wget -q -O - http://.../settings.sh | sh
cat <<INTRO
       __      __  _____ __             ____                    __                __       
  ____/ /___  / /_/ __(_) /__  _____   / __/___  _____   __  __/ /_  __  ______  / /___  __
 / __  / __ \/ __/ /_/ / / _ \/ ___/  / /_/ __ \/ ___/  / / / / __ \/ / / / __ \/ __/ / / /
/ /_/ / /_/ / /_/ __/ / /  __(__  )  / __/ /_/ / /     / /_/ / /_/ / /_/ / / / / /_/ /_/ / 
\__,_/\____/\__/_/ /_/_/\___/____/  /_/  \____/_/      \__,_/_.___/\__,_/_/ /_/\__/\__,_(_)
                                                                                           
INTRO

echo "Executing this shell script will perform the initial configuration and application installation."

read -p "OK? [Y/n]: " ANSWER

case "$ANSWER" in
    "" | "yes" | "Yes" | "y" | "Y")
        echo "Let's go."
        ;;
    * )
        echo "Cancel."
        exit 0
        ;;
esac

# 初期設定

# ディレクトリ名を日本語表記から英語表記に変更
env LANGUAGE=C LC_MESSAGES=C xdg-user-dirs-gtk-update

# 最初に必要なものをインストール。

sudo apt install -y git

# oh-my-zsh clone
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

# dotfiles clone
git clone https://github.com/takuyaw-w/dotfiles.git
# リポジトリの中の.zshrcなどのシンボリックリンクを貼る
ln -sfv ~/dotfiles/.zshrc
ln -sfv ~/dotfiles/.gitconfig
ln -sfv ~/dotfiles/.bashrc

source ~/.zshrc

# アプリケーションのインストール

# curl
sudo apt install -y curl
# vscode
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt install -y apt-transport-https
sudo apt update
sudo apt install -y code
# tree
sudo apt install -y tree
# docker
sudo snap install -y docker
# go language
sudo snap install go --classic
# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# deno
curl -fsSL https://deno.land/x/install/install.sh | sh
# git-lfs
sudo apt install -y git-lfs
# git-flow
sudo apt install -y git-flow
# lazygit
sudo add-apt-repository ppa:lazygit-team/release
sudo apt update
sudo apt install -y lazygit
# libreoffice
sudo snap install -y libreoffice
# fonts
sudo apt install -y fonts-roboto
sudo apt install -y fonts-noto
sudo apt install -y fonts-ricty-diminished
# gnome-tweaks
sudo apt install -y gnome-tweaks
# gimp
sudo snap install -y gimp
# thunderbird
sudo snap install -y thunderbird
# zsh
sudo apt install -y zsh
# byobu
sudo apt install -y byobu
# ghq
export PATH="$PATH:/snap/bin"
go get github.com/x-motemen/ghq
# peco
sudo apt install -y peco
# ubuntu-cleaner
sudo add-apt-repository -y ppa:gerardpuig/ppa
sudo apt update
sudo apt install -y ubuntu-cleaner
# ppa:git-core
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt update
# chromium
sudo snap install -y chromium
# build-essential
sudo apt install -y build-essential
# virtualenv
sudo apt install -y virtualenv
# virtualenvwrapper
sudo apt install -y virtualenvwrapper
# powerline
sudo apt install -y powerline
# fonts-powerline
sudo apt install -y fonts-powerline
