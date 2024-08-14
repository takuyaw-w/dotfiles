# Aliases

alias open="xdg-open"
alias vim="nvim"

# ls command
if command "exa" -v >/dev/null 2>&1; then
  alias ls="exa"
  alias ll="exa -hal --git --time-style=long-iso --group-directories-first"
  alias tree="exa -T"
else
  alias ls="ls --color=auto"
fi

# cat command
if command "bat" --version >/dev/null 2>&1; then
  alias cat="bat"
fi

# grep command
if command "rg" -v >/dev/null 2>&1; then
  alias grep="rg"
else
  alias grep="grep --color=auto"
  alias egrep="egrep --color=auto"
fi

# rm command
if command "gomi" --help >/dev/null 2>&1; then
  alias rm="gomi"
fi

function extract() {
  case $1 in
  *.tar.gz | *.tgz) tar xzvf "$1" ;;
  *.tar.xz) tar Jxvf "$1" ;;
  *.zip) unzip "$1" ;;
  *.lzh) lha e "$1" ;;
  *.tar.bz2 | *.tbz) tar xjvf "$1" ;;
  *.tar.Z) tar zxvf "$1" ;;
  *.gz) gzip -d "$1" ;;
  *.bz2) bzip2 -dc "$1" ;;
  *.Z) uncompress "$1" ;;
  *.tar) tar xvf "$1" ;;
  *.arj) unarj "$1" ;;
  esac
}
alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}="extract"

alias pathlist="echo $PATH | sed -e 's/:/\n/g'"
alias sail='[ -f sail ] && bash sail || bash vendor/bin/sail'

if command -v "docker" >/dev/null 2>&1; then
  alias d='docker'
  alias dps='docker ps'
  alias dpsa='docker ps -a'
  alias di='docker images'
  alias dr='docker run'
  alias drm='docker rm'
  alias drmi='docker rmi'
  alias dst='docker start'
  alias dstp='docker stop'
  alias dpl='docker pull'
  alias dbuild='docker build'
  alias dexec='docker exec -it'
  alias dlogs='docker logs'
  alias dlogs_follow='docker logs -f'
  alias dst_all='docker stop $(docker ps -q)'
  alias drm_all='docker rm $(docker ps -aq)'
  alias drmi_all='docker rmi $(docker images -q)'
  alias dclean='docker system prune -af'
fi

if command -v "docker-compose" >/dev/null 2>&1; then
  alias dc='docker compose'
  alias dcu='docker compose up'
  alias dcud='docker compose up -d'
  alias dcd='docker compose down'
  alias dcr='docker compose restart'
  alias dcb='docker compose build'
  alias dcl='docker compose logs'
  alias dclf='docker compose logs -f'
  alias dce='docker compose exec'
  alias dcp='docker compose ps'
  alias dcrebuild='docker-compose down && docker-compose up --build'
fi
