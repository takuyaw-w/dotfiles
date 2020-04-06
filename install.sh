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

# oh-my-zsh clone
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

# dotfiles clone
git clone https://github.com/takuyaw-w/dotfiles.git
# リポジトリの中の.zshrcなどのシンボリックリンクを貼る
ln -sfv ~/dotfiles/.zshrc .zshrc
ln -sfv ~/dotfiles/.gitconfig .gitconfig
ln -sfv ~/dotfiles/.bashrc . bashrc
ln -sfv ~/dotfiles/settings.json .config/Code/User

source ~/.zshrc

# アプリケーションのインストール

# vscodeのリポジトリ登録
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
# 各PPA
sudo add-apt-repository -y ppa:lazygit-team/release
sudo add-apt-repository -y ppa:gerardpuig/ppa
sudo add-apt-repository -y ppa:git-core/ppa

# update
sudo apt update
sudo apt -y upgrade
sudo apt -y dist-upgrade
sudo snap refresh

# curl
sudo apt install -y curl
# tree
sudo apt install -y tree
# apt-transport-https
sudo apt install -y apt-transport-https
# vscode
sudo apt install -y code
# docker
sudo snap install -y docker
# go language
sudo snap install -y go --classic
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
sudo snap install -y libreoffice
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
go get github.com/x-motemen/ghq
# peco
sudo apt install -y peco
# ubuntu-cleanerx
sudo apt install -y ubuntu-cleaner
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
# fonts
sudo apt install -y fonts-powerline
sudo apt install -y fonts-roboto
sudo apt install -y fonts-noto
sudo apt install -y fonts-ricty-diminished
