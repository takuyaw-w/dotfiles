# Key Bindings

function ghq-fzf() {
  local selected_dir=$(ghq list | fzf --query="$LBUFFER" --preview "bat --color=always --style=header,grid --line-range :80 $(ghq root)/{}/README.*")

  if [ -n "$selected_dir" ]; then
    BUFFER="cd $(ghq root)/${selected_dir}"
    zle accept-line
  fi

  zle reset-prompt
}

zle -N ghq-fzf
bindkey "^]" ghq-fzf
