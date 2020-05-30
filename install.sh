#!/bin/env bash

# 初期設定
cat <<INTRO
       __      __  _____ __             ____                    __                __       
  ____/ /___  / /_/ __(_) /__  _____   / __/___  _____   __  __/ /_  __  ______  / /___  __
 / __  / __ \/ __/ /_/ / / _ \/ ___/  / /_/ __ \/ ___/  / / / / __ \/ / / / __ \/ __/ / / /
/ /_/ / /_/ / /_/ __/ / /  __(__  )  / __/ /_/ / /     / /_/ / /_/ / /_/ / / / / /_/ /_/ / 
\__,_/\____/\__/_/ /_/_/\___/____/  /_/  \____/_/      \__,_/_.___/\__,_/_/ /_/\__/\__,_(_)
INTRO

#######################################
# パッケージを最新へ更新
#######################################
sudo -v &> /dev/null
sudo apt update
sudo apt -y upgrade
sudo apt -y dist-upgrade
sudo apt autoremove

#######################################
# ディレクトリ名を日本語表記から英語表記に変更
#######################################
env LANGUAGE=C LC_MESSAGES=C xdg-user-dirs-gtk-update

#######################################
# gitconfig.localへユーザー名、メールアドレスの設定
#######################################

GIT_CONFIG_LOCAL=$HOME/.gitconfig.local
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

#######################################
# リポジトリの中の.zshrcなどのシンボリックリンクを貼る
#######################################
ln -sfv $HOME/dotfiles/.zshrc $HOME/.zshrc
ln -sfv $HOME/dotfiles/.gitconfig $HOME/.gitconfig
if [ ! -e $HOME/.vim ]; then
  mkdir $HOME/.vim
fi
ln -sfv $HOME/dotfiles/vim/.vimrc $HOME/.vim/.vimrc
ln -sfv $HOME/dotfiles/vim/dein.toml $HOME/.vim/dein.toml

#######################################
# アプリケーションのインストール
#######################################

# 必要なP変数を登録
export NVM_DIR="$HOME/.nvm"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

##########################################
# PPAや必要なリポジトリの登録
##########################################
echo add-apt-repository lazygit
sudo add-apt-repository -y ppa:lazygit-team/release
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

#######################################
# ユーティリティー
#######################################

echo install curl
sudo apt install -y curl
echo install wget
sudo apt install -y wget
echo install tree
sudo apt install -y tree
echo install git-lfs
sudo apt install -y git-lfs
echo install git-flow
sudo apt install -y git-flow
echo install peco
sudo apt install -y peco
echo install build-essential
sudo apt install -y build-essential
echo install virtualenv
sudo apt install -y virtualenv
echo install virtualenvwrapper
sudo apt install -y virtualenvwrapper
echo install apt-transport-https
sudo apt install -y apt-transport-https
echo install ca-certificates
sudo apt install ca-certificates
echo install gnupg-agent
sudo apt install gnupg-agent
echo install software-properties-common
sudo apt install software-properties-common
echo install lazygit
sudo apt install -y lazygit
echo install zsh
sudo apt install -y zsh
echo install tmux
sudo apt install -y tmux
sudo apt install -y ncurses-dev
sudo apt install -y lua5.2
sudo apt install -y lua5.2-dev
sudo apt install -y luajit
sudo apt install -y python-dev
sudo apt install -y python3-dev
sudo apt install -y ruby-dev

#######################################
# フォント系
#######################################
echo install fonts
sudo apt install -y powerline
sudo apt install -y fonts-powerline
sudo apt install -y fonts-roboto
sudo apt install -y fonts-noto
sudo apt install -y fonts-ricty-diminished

#######################################
# 言語
#######################################

# Rust
echo install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile default --default-toolchain stable -y
source $HOME/.cargo/env

# go language
echo golang
wget https://dl.google.com/go/go1.14.3.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.14.3.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
sudo rm -rf go1.14.3.linux-amd64.tar.gz
mkdir $HOME/go

# deno
echo install deno
curl -fsSL https://deno.land/x/install/install.sh | sh

# nodejs install
# nvm
echo install nvm
git clone https://github.com/nvm-sh/nvm.git .nvm
cd $HOME/.nvm
# LATEST=$(curl -s -I https://github.com/nvm-sh/nvm/releases/latest | grep location | cut -d / -f8)
git checkout v0.35.3
source nvm.sh
# nodejs
echo install nodejs
nvm install --lts --latest-npm
nvm alias default lts/*

#######################################
# エディター
#######################################

echo install code
sudp apt install -y code

# vim
ghq get https://github.com/vim/vim
cd $HOME/ghq/github.com/vim/vim
sudo ./configure \
  --with-features=huge \
  --enable-multibyte \
  --enable-luainterp=dynamic \
  --enable-gpm \
  --enable-cscope \
  --enable-fontset \
  --enable-fail-if-missing \
  --prefix=/usr/local \
  --enable-pythoninterp=dynamic \
  --enable-python3interp=dynamic \
  --enable-rubyinterp=dynamic 
sudo make
sudo make install
cd $HOME

#######################################
# その他
#######################################

echo install libreoffice
sudo apt install -y libreoffice
echo install thunderbird
sudo apt install -y thunderbird
echo install gimp
sudo apt install -y gimp
echo install google chrome
sudo apt install -y google-chrome-stable
echo install ghq
go get github.com/x-motemen/ghq
ghq get https://github.com/gohugoio/hugo.git
cd $HOME/ghq/github.com/gohugoio/hugo
go install --tags extended
cd $HOME
# docker
echo install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update 
sudo apt install docker-ce docker-ce-cli containerd.io
sudo systemctl enable --now docker
sudo usermod -aG docker "$(whoami)"
# docker-compose
# COMPOSER_VERSION=$(curl -s -I https://github.com/docker/compose/releases/latest | grep location | cut -d / -f8)
echo install docker-compose version #$COMPOSER_VERSION
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# oh-my-zsh clone
echo clone oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

chsh -s "$(which zsh)"

exec $SHELl -l
