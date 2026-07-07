# functions
function ghq-fzf() {
  local selected_dir=$(ghq list | fzf --query="$LBUFFER" --preview "bat --color=always --style=header,grid --line-range :80 $(ghq root)/{}/README.*")

  if [ -n "$selected_dir" ]; then
    BUFFER="cd $(ghq root)/${selected_dir}"
    zle accept-line
  fi

  zle reset-prompt
}

function ghq-update() {
  ghq list | ghq get --update --parallel
}

function ghq-export() {
  ghq list > repolist.txt
}

function ghq-import() {
  cat $1 | ghq get --parallel
}
