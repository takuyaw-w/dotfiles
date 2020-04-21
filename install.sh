#!bin/bash

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

# 一旦いろいろアップデート
sudo apt update
sudo apt -y upgrade
sudo apt -y dist-upgrade
sudo snap refresh

# ディレクトリ名を日本語表記から英語表記に変更
env LANGUAGE=C LC_MESSAGES=C xdg-user-dirs-gtk-update

# 最初に必要なものをインストール。

sudo apt install -y git

GIT_CONFIG_LOCAL=~/.gitconfig.local
if [ ! -e $GIT_CONFIG_LOCAL ]; then
	echo -n "git config user.email?> "
	read GIT_AUTHOR_EMAIL

	echo -n "git config user.name?> "
	read GIT_AUTHOR_NAME

	cat << EOF > $GIT_CONFIG_LOCAL
[user]
    name = $GIT_AUTHOR_NAME
    email = $GIT_AUTHOR_EMAIL
EOF
fi

# アプリケーションのインストール

# 各PPA
sudo add-apt-repository -y ppa:lazygit-team/release
sudo add-apt-repository -y ppa:gerardpuig/ppa
sudo add-apt-repository -y ppa:git-core/ppa

# curl
sudo apt install -y curl
# tree
sudo apt install -y tree
# vscode
sudo snap install code --classic
# docker
sudo snap install docker
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
sudo apt install -y lazygit
# libreoffice
sudo snap install libreoffice
# gnome-tweaks
sudo apt install -y gnome-tweaks
# gimp
sudo snap install gimp
# thunderbird
sudo snap install thunderbird
# zsh
sudo apt install -y zsh
# byobu
sudo apt install -y byobu
# ghq
go get github.com/x-motemen/ghq
# peco
sudo apt install -y peco
# ubuntu-cleanerx
sudo apt install -y ubuntu-cleaner
# chromium
sudo snap install chromium
# build-essential
sudo apt install -y build-essential
# virtualenv
sudo apt install -y virtualenv
# virtualenvwrapper
sudo apt install -y virtualenvwrapper
# nvm
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
nvm install --lts --latest-npm
nvm alias default lts/*
# powerline
sudo apt install -y powerline
# fonts
sudo apt install -y fonts-powerline
sudo apt install -y fonts-roboto
sudo apt install -y fonts-noto
sudo apt install -y fonts-ricty-diminished

# oh-my-zsh clone
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

# dotfiles clone
git clone https://github.com/takuyaw-w/dotfiles.git
# リポジトリの中の.zshrcなどのシンボリックリンクを貼る
ln -sfv ~/dotfiles/.zshrc ~/.zshrc
ln -sfv ~/dotfiles/.gitconfig ~/.gitconfig
ln -sfv ~/dotfiles/.bashrc ~/.bashrc

chsh -s $(which zsh)

exec $SHELl
