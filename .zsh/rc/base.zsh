# Base Configuration
HOSTNAME="$HOST"
HISTFILE="$ZHOMEDIR/.zsh_history" # ヒストリ保存ファイル
HISTSIZE=10000                    # メモリ内の履歴の数
SAVEHIST=100000                   # 保存される履歴の数
HISTORY_IGNORE="(exit|zsh|pwd)"
LISTMAX=1000                      # 補完リストを尋ねる数 (1=黙って表示, 0=ウィンドウから溢れるときは尋ねる)
KEYTIMEOUT=1

fpath=($HOME/.zfunc(N-/) $ZHOMEDIR/zfunc(N-/) $ZHOMEDIR/completion(N-/) $fpath)

# カレントディレクトリ中にサブディレクトリが無い場合に cd が検索するディレクトリのリスト
cdpath=("$HOME" .. $HOME/*)

# autoload
autoload -Uz run-help
autoload -Uz add-zsh-hook
autoload -Uz colors && colors
autoload -Uz is-at-least

# core
ulimit -c unlimited

# ファイル作成時のパーミッション
umask 022

export DISABLE_DEVICONS=false
