#!bin/env bash

# 初期設定
# wget -qO- https://raw.githubusercontent.com/takuyaw-w/dotfiles/master/install.sh | sh
cat <<INTRO
       __      __  _____ __             ____                    __                __       
  ____/ /___  / /_/ __(_) /__  _____   / __/___  _____   __  __/ /_  __  ______  / /___  __
 / __  / __ \/ __/ /_/ / / _ \/ ___/  / /_/ __ \/ ___/  / / / / __ \/ / / / __ \/ __/ / / /
/ /_/ / /_/ / /_/ __/ / /  __(__  )  / __/ /_/ / /     / /_/ / /_/ / /_/ / / / / /_/ /_/ / 
\__,_/\____/\__/_/ /_/_/\___/____/  /_/  \____/_/      \__,_/_.___/\__,_/_/ /_/\__/\__,_(_)
INTRO

# 初期設定
sudo -v &> /dev/null

# 一旦いろいろアップデート
sudo apt update
sudo apt -y upgrade
sudo apt -y dist-upgrade
sudo snap refresh
sudo apt autoremove

# ディレクトリ名を日本語表記から英語表記に変更
# env LANGUAGE=C LC_MESSAGES=C xdg-user-dirs-gtk-update

# 最初に必要なものをインストール。

# GIT_CONFIG_LOCAL=~/.gitconfig.local
# if [ ! -e $GIT_CONFIG_LOCAL ]; then
# 	echo -n "git config user.email?> "
# 	read GIT_AUTHOR_EMAIL

# 	echo -n "git config user.name?> "
# 	read GIT_AUTHOR_NAME

# 	cat << GITCONFIG > $GIT_CONFIG_LOCAL
# [user]
#     name = $GIT_AUTHOR_NAME
#     email = $GIT_AUTHOR_EMAIL
# GITCONFIG
# fi

# アプリケーションのインストール

# 各PPA
echo add-apt-repository lazygit
sudo add-apt-repositadd-apt-repositoryory -y ppa:lazygit-team/release
echo add-apt-repository gerardpuig
sudo add-apt-repository -y ppa:gerardpuig/ppa
echo add-apt-repository git-core
sudo add-apt-repository -y ppa:git-core/ppa

# libreoffice
echo install libreoffice
sudo snap install libreoffice
# gimp
echo install gimp
sudo snap install gimp
# thunderbird
echo install thunderbird
sudo snap install thunderbird --beta
# Hugo
echo hugo
sudo snap install hugo

# TODO: ubuntu 20.04 focal fossa
# docker
echo install docker
sudo apt install -y docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker $(whoami)
# docker-compose
echo install docker-compose
sudo apt install -y docker-compose
# vim
echo install vim
sudo apt install -y vim
# git
echo install git
sudo apt install -y git
# curl
echo install curl
sudo apt install -y curl
# tree
echo install tree
sudo apt install -y tree
# Rust
echo install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# deno
echo install deno
curl -fsSL https://deno.land/x/install/install.sh | sh
# git-lfs
echo install git-lfs
sudo apt install -y git-lfs
# git-flow
echo install git-flow
sudo apt install -y git-flow
# lazygit
echo install lazygit
sudo apt install -y lazygit
# gnome-tweaks
echo install gnome-tweaks
sudo apt install -y gnome-tweaks
# zsh
echo install zsh
sudo apt install -y zsh
# byobu
echo install byobu
sudo apt install -y byobu
# go language
echo golang
#wget https://dl.google.com/go/go1.14.3.linux-amd64.tar.gz
#tar -C /usr/local -xzf go1.14.3.linux-amd64.tar.gz
#export PATH=$PATH:/usr/local/go/bin
# ghq
#echo install ghq
#go get github.com/x-motemen/ghq
# peco
echo install peco
sudo apt install -y peco
# build-essential
echo install build-essential
sudo apt install -y build-essential
# virtualenv
echo install virtualenv
sudo apt install -y virtualenv
# virtualenvwrapper
echo install virtualenvwrapper
sudo apt install -y virtualenvwrapper
# nvm
echo install nvm
git clone https://github.com/nvm-sh/nvm.git .nvm
cd ~/.nvm
git checkout v0.35.3
source nvm.sh
(
  cd "$NVM_DIR"
  git fetch --tags origin
  git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
) && \. "$NVM_DIR/nvm.sh"
# nodejs
echo install nodejs
nvm install --lts --latest-npm
nvm alias default lts/*
# powerline
echo install fonts
sudo apt install -y powerline
# fonts
sudo apt install -y fonts-powerline
sudo apt install -y fonts-roboto
sudo apt install -y fonts-noto
sudo apt install -y fonts-ricty-diminished

# oh-my-zsh clone
echo clone oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

# dotfiles clone
echo clone dotfile
git clone https://github.com/takuyaw-w/dotfiles.git
# リポジトリの中の.zshrcなどのシンボリックリンクを貼る
ln -sfv ~/dotfiles/.zshrc ~/.zshrc
ln -sfv ~/dotfiles/.gitconfig ~/.gitconfig
ln -sfv ~/dotfiles/.bashrc ~/.bashrc
ln -sfv ~/dotfiles/vim/.vimrc ~/.vimrc
ln -sfv ~/dotfiles/vim/dein.toml ~/.vim/dein.toml

chsh -s $(which zsh)

exec $SHELl -l
