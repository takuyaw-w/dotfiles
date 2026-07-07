#!/usr/bin/env bash

set -euo pipefail

export HOME=${HOME:-/tmp/dotfiles-home}
export DOTFILES_SKIP_HOME_MANAGER=${DOTFILES_SKIP_HOME_MANAGER:-1}
export DOTFILES_USE_SUDO=${DOTFILES_USE_SUDO:-0}

mkdir -p "$HOME"
cd /workspace

bash -n dotfiles.sh scripts/lib/*.sh tests/*.sh tests/docker/*.sh
bash tests/install-ci-control.sh
bash tests/docker-runner-test.sh
bash tests/dotfiles-cli-test.sh

./dotfiles.sh install

test ! -e "$HOME/.zshrc"
test ! -e "$HOME/.zshenv"
test ! -e "$HOME/.config/git/config"
test ! -e "$HOME/.gitconfig.local"

command -v curl >/dev/null
command -v git >/dev/null
command -v zsh >/dev/null

printf 'ok - docker smoke test\n'
