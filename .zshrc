# ZSHRC

# profile
if [ "$ZSHRC_PROFILE" != "" ]; then
  zmodload zsh/zprof && zprof >/dev/null
fi

# base configuration

source-safe() {
  if [ -f "$1" ]; then
    source "$1"
  fi
}

source "$ZRCDIR/base.zsh"

# Options

source "$ZRCDIR/option.zsh"

# Completion

source "$ZRCDIR/completion.zsh"

# Prompt Configuration

source "$ZRCDIR/prompt.zsh"

# Function

source "$ZRCDIR/function.zsh"

# Alias

source "$ZRCDIR/alias.zsh"

# BindKeys

source "$ZRCDIR/bindkey.zsh"

# Plugins

source "$ZRCDIR/pluginlist.zsh"

# Command Config

source "$ZRCDIR/command_config.zsh"

# Post Execute

source "$ZRCDIR/post_load.zsh"

# Execute Scripts

source-safe "$ZDOTDIR/.zshrc.local"
source-safe "$ZHOMEDIR/.zshrc.local"
