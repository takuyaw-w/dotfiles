# Setup zinit
if [ -z "$ZPLG_HOME" ]; then
  ZPLG_HOME="$ZDATADIR/zinit"
fi

if ! test -d "$ZPLG_HOME"; then
  mkdir -p "$ZPLG_HOME"
  chmod g-rwX "$ZPLG_HOME"
  git clone --depth 10 https://github.com/zdharma/zinit.git ${ZPLG_HOME}/bin
fi

typeset -gAH ZPLGM
ZPLGM[HOME_DIR]="${ZPLG_HOME}"
source "$ZPLG_HOME/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit


# #==============================================================#
# ## Plugin load                                                ##
# #==============================================================#

zinit light-mode for \
  @zinit-zsh/z-a-readurl \
  @zinit-zsh/z-a-patch-dl \
  @zinit-zsh/z-a-bin-gem-node \
  @zinit-zsh/z-a-unscope \
  @zinit-zsh/z-a-default-ice \
  @zinit-zsh/z-a-submods

# 補完
zinit light zsh-users/zsh-autosuggestions

# シンタックスハイライト
zinit light zdharma/fast-syntax-highlighting

# Ctrl+r でコマンド履歴を検索
zinit light zdharma/history-search-multi-word

# クローンしたGit作業ディレクトリで、コマンド `git open` を実行するとブラウザでGitHubが開く
zinit light paulirish/git-open

# #==============================================================#
# # local plugins
# #==============================================================#
# [ -f "$HOME/.zshrc.plugin.local" ] && source "$HOME/.zshrc.plugin.local"
