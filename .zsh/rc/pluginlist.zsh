# Setup zinit
if [ -z "$ZPLG_HOME" ]; then
  ZPLG_HOME="$ZDATADIR/zinit"
fi

if ! test -d "$ZPLG_HOME"; then
  mkdir -p "$ZPLG_HOME"
  chmod g-rwX "$ZPLG_HOME"
  git clone https://github.com/zdharma-continuum/zinit.git ${ZPLG_HOME}/bin
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
  @zdharma-continuum/zinit-annex-readurl \
  @zdharma-continuum/z-a-patch-dl \
  @zdharma-continuum/z-a-bin-gem-node \
  @zdharma-continuum/z-a-unscope \
  @zdharma-continuum/z-a-default-ice \
  @zdharma-continuum/z-a-submods

# 補完
zinit light zsh-users/zsh-autosuggestions

# シンタックスハイライト
zinit light zdharma-continuum/fast-syntax-highlighting

# Ctrl+r でコマンド履歴を検索
zinit light zdharma-continuum/history-search-multi-word

# クローンしたGit作業ディレクトリで、コマンド `git open` を実行するとブラウザでGitHubが開く
zinit light paulirish/git-open

# #==============================================================#
# # local plugins
# #==============================================================#
# [ -f "$HOME/.zshrc.plugin.local" ] && source "$HOME/.zshrc.plugin.local"
