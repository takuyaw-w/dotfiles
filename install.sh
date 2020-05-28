#!/bin/env bash

# 初期設定
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
sudo apt autoremove

# ディレクトリ名を日本語表記から英語表記に変更
env LANGUAGE=C LC_MESSAGES=C xdg-user-dirs-gtk-update

# 最初に必要なものをインストール。

GIT_CONFIG_LOCAL=~/.gitconfig.local
if [ ! -e $GIT_CONFIG_LOCAL ]; then
	echo -n "git config user.email?> "
	read GIT_AUTHOR_EMAIL

	echo -n "git config user.name?> "
	read GIT_AUTHOR_NAME

	cat << GITCONFIG > $GIT_CONFIG_LOCAL
[user]
    name = $GIT_AUTHOR_NAME
    email = $GIT_AUTHOR_EMAIL
GITCONFIG
fi

# リポジトリの中の.zshrcなどのシンボリックリンクを貼る
ln -sfv ~/dotfiles/.zshrc ~/.zshrc
ln -sfv ~/dotfiles/.gitconfig ~/.gitconfig
ln -sfv ~/dotfiles/.bashrc ~/.bashrc
ln -sfv ~/dotfiles/vim/.vimrc ~/.vimrc
if [ ! -e ~/.vim ]; then
  mkdir .vim
fi
ln -sfv ~/dotfiles/vim/dein.toml ~/.vim/dein.toml

# アプリケーションのインストール
export ZSH=$HOME/.oh-my-zsh
echo $ZSH
export DENO_INSTALL="$HOME/.deno"
echo $DENO_INSTALL
export PATH="$DENO_INSTALL/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
echo $NVM_DIR
export GOPATH="$HOME/.go"
echo $GOPATH
export PATH="$GOPATH/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# 各PPA
echo add-apt-repository lazygit
sudo add-apt-repositadd-apt-repositoryory -y ppa:lazygit-team/release
echo add-apt-repository git-core
sudo add-apt-repository -y ppa:git-core/ppa
echo add-apt-repository libreoffice-6-4
sudo add-apt-repository -y ppa:libreoffice/libreoffice-6-4
echo add-apt-repository ppa:otto-kesselgulasch/gimp
sudo add-apt-repository -y ppa:otto-kesselgulasch/gimp
echo add-apt-repository mozillateam/ppa
sudo add-apt-repository -y ppa:mozillateam/ppa
echo google-chrome repository
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
sudo wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo visual-studio-code repository
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo rm -rf packages.microsoft.gpg

sudo apt update
sudo apt -y upgrade
sudo apt -y dist-upgrade

echo install apt-transport-https
sudo apt install -y apt-transport-https
echo install code
sudp apt install -y code
echo install libreoffice
sudo apt install -y libreoffice
echo install thunderbird
sudo apt install -y thunderbird
echo install gimp
sudo apt install -y gimp
# docker
echo install docker
sudo apt install -y docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker "$(whoami)"
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
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile default --default-toolchain stable -y
source $HOME/.cargo/env
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
# zsh
echo install zsh
sudo apt install -y zsh
# tmux
echo install tmux
sudo apt install -y tmux
# go language
echo golang
wget https://dl.google.com/go/go1.14.3.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.14.3.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
sudo rm -rf go1.14.3.linux-amd64.tar.gz
mkdir $HOME/.go
# ghq
echo install ghq
go get github.com/x-motemen/ghq
# hugo
ghq get https://github.com/gohugoio/hugo.git
cd $HOME/.ghq/github.com/gohugoio/hugo
go install --tags extended
cd ~
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
# google chrome
sudo apt install -y google-chrome-stable

# oh-my-zsh clone
echo clone oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

chsh -s "$(which zsh)"

exec $SHELl -l
