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

function reboot-fcitx5() {
  kill `ps -A | grep fcitx5 | awk '{print $1}'` && fcitx5&
}

function tmux-ide() {
  tmux
  if [ "$#" -eq 0 ]; then
    tmux split-window -v
    tmux split-window -h
    tmux resize-pane -D 15
    tmux select-pane -t 1
  else
    case $1 in
    1)
      tmux split-window -v
      tmux resize-pane -D 15
      tmux select-pane -D
      clear
      ;;
    2)
      tmux split-window -h
      tmux split-window -v
      tmux resize-pane -D 15
      tmux select-pane -t 1
      tmux split-window -v
      tmux select-pane -t 1
      clear
      ;;
    *)
      echo [ERROR] "$1" は設定されていない引数です。
      ;;
    esac
  fi
}
