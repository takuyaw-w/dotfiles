# Aliases

# ls command
if command "exa" -v > /dev/null 2>&1; then
  alias ls="exa"
  alias tree="exa -T"
else
  alias ls="ls --color=auto"
fi

# cat command
if command "bat" -v > /dev/null 2>&1; then
  alias cat="bat"
fi

alias grep="grep --color=auto"
alias egrep="egrep --color=auto"

ex() {
  if [ -f $1 ]; then
    case $1 in
    *.tar.bz2) tar xjf $1 ;;
    *.tar.gz) tar xzf $1 ;;
    *.bz2) bunzip2 $1 ;;
    *.rar) unrar x $1 ;;
    *.gz) gunzip $1 ;;
    *.tar) tar xf $1 ;;
    *.tbz2) tar xjf $1 ;;
    *.tgz) tar xzf $1 ;;
    *.zip) unzip $1 ;;
    *.Z) uncompress $1 ;;
    *.7z) 7z x $1 ;;
    *) echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
