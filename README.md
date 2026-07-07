# dotfiles

Manjaro Linux / Ubuntu / Fedora で使うための dotfiles。

基本方針は、共通の CLI / 開発環境を Nix + Home Manager に寄せること。
各 distro のパッケージマネージャーは、最小限の bootstrap と desktop 固有設定だけで使う。

## Usage

初回セットアップ。

```sh
git clone https://github.com/takuyaw-w/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

Nix がまだ入っていない場合。

```sh
sh <(curl -L https://nixos.org/nix/install) --daemon
```

Home Manager コマンドがまだない場合。

```sh
nix profile install github:nix-community/home-manager
```

中で何をやるか分けて実行したい場合。

```sh
~/.dotfiles/dotfiles.sh doctor
~/.dotfiles/dotfiles.sh bootstrap
~/.dotfiles/dotfiles.sh gitconfig
~/.dotfiles/dotfiles.sh switch
```

まとめて実行する場合。

```sh
~/.dotfiles/dotfiles.sh install
```

desktop 固有設定は別で実行する。

```sh
~/.dotfiles/dotfiles.sh desktop
```

## コマンド

```text
dotfiles.sh doctor     現在の環境を確認する
dotfiles.sh bootstrap  distro 側の最小パッケージを入れる
dotfiles.sh gitconfig  ~/.gitconfig.local の状態を確認する
dotfiles.sh switch     Home Manager を switch する
dotfiles.sh install    bootstrap / gitconfig / switch を実行する
dotfiles.sh desktop    desktop 固有設定を実行する
```

## 設定ファイル

`.zshrc` / `.zshenv` / `.zsh` / `.config/*` は Home Manager
で配置する。

`dotfiles.sh switch` を実行すると、Home Manager が `$HOME` に設定ファイルを
反映する。

Home Manager の設定は `home-manager/` に置く。

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
bash -n dotfiles.sh install.sh scripts/lib/*.sh
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

Home Manager activation package の build。

```sh
nix build .#homeConfigurations.takuya-x86_64-linux.activationPackage --no-link
```
