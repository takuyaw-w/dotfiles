# Aliases

alias open="xdg-open"

# ls command
if command "exa" -v > /dev/null 2>&1; then
  alias ls="exa"
  alias ll="exa -hal --git --time-style=long-iso --group-directories-first"
  alias tree="exa -T"
else
  alias ls="ls --color=auto"
fi

# cat command
if command "bat" -v > /dev/null 2>&1; then
  alias cat="bat"
fi

# grep command
if command "rg" -v > /dev/null 2>&1; then
  alias grep="rg"
else
  alias grep="grep --color=auto"
  alias egrep="egrep --color=auto"
fi

function extract() {
  case $1 in
    *.tar.gz|*.tgz) tar xzvf "$1";;
    *.tar.xz) tar Jxvf "$1";;
    *.zip) unzip "$1";;
    *.lzh) lha e "$1";;
    *.tar.bz2|*.tbz) tar xjvf "$1";;
    *.tar.Z) tar zxvf "$1";;
    *.gz) gzip -d "$1";;
    *.bz2) bzip2 -dc "$1";;
    *.Z) uncompress "$1";;
    *.tar) tar xvf "$1";;
    *.arj) unarj "$1";;
  esac
}
alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}="extract"

# ghq command
function ghq_create() {
  ghq create $1
}
alias ghqc="ghq_create"
