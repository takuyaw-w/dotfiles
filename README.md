# dotfiles

Manjaro Linux / Ubuntu / Fedora で使うための dotfiles。

基本方針は、共通の CLI / 開発環境を Nix + Home Manager に寄せること。
各 distro のパッケージマネージャーは、最小限の bootstrap と desktop 固有設定だけで使う。

## Usage

```sh
# initial check
git clone https://github.com/takuyaw-w/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
~/.dotfiles/dotfiles.sh doctor
```

```sh
# if Nix is missing
sh <(curl -L https://nixos.org/nix/install) --daemon
exec "$SHELL" -l
```

```sh
# if Home Manager is missing
nix profile install github:nix-community/home-manager
```

```sh
# if ~/.gitconfig.local is missing
cat >~/.gitconfig.local <<'GITCONFIG'
[user]
    name = Your Name
    email = you@example.com
GITCONFIG
```

```sh
# check again, then apply
~/.dotfiles/dotfiles.sh doctor
~/.dotfiles/dotfiles.sh install
```

```sh
# equivalent explicit steps
~/.dotfiles/dotfiles.sh bootstrap
~/.dotfiles/dotfiles.sh gitconfig
~/.dotfiles/dotfiles.sh switch
```

```sh
# reapply after changing dotfiles
cd ~/.dotfiles
~/.dotfiles/dotfiles.sh switch
```

```sh
# reapply without home-manager on PATH
NIX_USERNAME="$(id -un)" NIX_HOME_DIRECTORY="$HOME" \
  nix run github:nix-community/home-manager -- switch --impure --flake ~/.dotfiles#desktop-x86_64-linux
```

```sh
# reload shell after PATH / zsh startup changes
exec zsh
```

```sh
# desktop setup
~/.dotfiles/dotfiles.sh desktop
```

```sh
# update flake.lock
~/.dotfiles/dotfiles.sh update
```

## コマンド

```text
dotfiles.sh doctor     現在の環境を確認する
dotfiles.sh bootstrap  distro 側の最小パッケージを入れる
dotfiles.sh gitconfig  ~/.gitconfig.local の状態を確認する
dotfiles.sh switch     Home Manager を switch する
dotfiles.sh install    bootstrap / gitconfig / switch を実行する
dotfiles.sh desktop    desktop 固有設定を実行する
dotfiles.sh update     flake.lock を更新して nix flake check を実行する
```

## Home Manager profiles

通常の実機では `dotfiles.sh switch` を使う。内部では現在の system に合わせて
`desktop-x86_64-linux` または `desktop-aarch64-linux` を選び、現在の user /
home directory を `NIX_USERNAME` / `NIX_HOME_DIRECTORY` として Home Manager に渡す。

直接 `home-manager` を実行する場合は、実行時の user / home directory を渡すため
`--impure` を使う。

```sh
NIX_USERNAME="$(id -un)" NIX_HOME_DIRECTORY="$HOME" \
  home-manager switch --impure --flake ~/.dotfiles#desktop-x86_64-linux
```

別 profile を試す場合は `DOTFILES_HOME_MANAGER_PROFILE` で上書きできる。

```sh
DOTFILES_HOME_MANAGER_PROFILE=desktop-x86_64-linux ~/.dotfiles/dotfiles.sh switch
```

CI / container 確認用には `test profile` として `test` を使う。これは GUI package を
含めず、`/home/test` を前提にした軽い Home Manager profile。

```sh
nix build .#homeConfigurations.test.activationPackage --no-link
```

## 設定ファイル

`.zshrc` / `.zshenv` / `.zsh` / `.config/*` は Home Manager
で配置する。

`dotfiles.sh switch` を実行すると、Home Manager が `$HOME` に設定ファイルを
反映する。

Home Manager の設定は `home-manager/` に置く。

- `home-manager/home.nix`: profile 共通の基本設定と module import
- `home-manager/shell.nix`: zsh startup files
- `home-manager/xdg.nix`: XDG config files と MIME default
- `home-manager/launchers.nix`: wezterm / x-terminal-emulator / x-www-browser
- `home-manager/gui.nix`: desktop GUI packages

この repository 独自の symlink script は使わない。

## Gitconfig

Git config 本体は `.config/git/config` を Home Manager で `$HOME` に配置する。
Nix の `programs.git` では管理しない。

Git の `user.name` / `user.email` は `~/.gitconfig.local` から読む。
installer と Home Manager はこのファイルを作らない。

ない場合は対象マシンで作る。

```ini
[user]
    name = Your Name
    email = you@example.com
```

最後に成功したら、ちゃんと自分で Gitconfig は設定する。

## Desktop

`dotfiles.sh desktop` で扱うもの。

- 日本語入力
- フォント
- ブラウザの MIME default

ここでは扱わないもの。

- Docker daemon の有効化

Chrome / VS Code は `home-manager/gui.nix` で管理する。

## 方針

- 共通の CLI / 開発ツールは Nix + Home Manager で管理する
- 設定ファイルも可能な限り Home Manager で管理する
- `mise` を runtime / tool manager として使う
- `fnm` は使わない
- Chrome / VS Code は `home-manager/gui.nix` で管理する
- distro の package manager は最小限にする
- desktop 固有の設定は `dotfiles.sh desktop` に分ける

## Test

shell script の syntax check。

```sh
bash -n dotfiles.sh scripts/lib/*.sh
```

installer 周りのテスト。

```sh
bash tests/install-ci-control.sh
bash tests/dotfiles-cli-test.sh
bash tests/docker-runner-test.sh
```

Docker で Ubuntu / Fedora / Manjaro をまとめて確認する。

```sh
tests/docker/run.sh all
```

個別に確認する。

```sh
tests/docker/run.sh ubuntu
tests/docker/run.sh fedora
tests/docker/run.sh manjaro
```

Nix flake の確認。

```sh
nix flake check
```

flake.lock の更新は、更新と検証をまとめた wrapper を使う。

```sh
~/.dotfiles/dotfiles.sh update
```

中身は以下を順に実行する。

```sh
nix flake update --flake ~/.dotfiles
nix flake check ~/.dotfiles
```

Home Manager activation package の build。

```sh
nix build .#homeConfigurations.desktop-x86_64-linux.activationPackage --no-link
```
