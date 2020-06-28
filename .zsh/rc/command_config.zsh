
function existsCommand() {
  builtin command -v $1 > /dev/null 2>&1
}

function source-safe() { if [ -f "$1" ]; then source "$1"; fi }

# pip completion

if existsCommand pip; then
  eval "$(pip completion --zsh)"
fi

# pipenv completion

if existsCommand pipenv; then
  eval "$(pipenv --completion)"
fi

# cargo completion

if existsCommand cargo; then
  d=$(readlink -f $HOME/.rustup/toolchains/*/share/zsh/site-functions)
  if [ -d "$d" ]; then
    fpath=($d $fpath)
  fi
fi

# fasd

if existsCommand fasd; then
  eval "$(fasd --init auto)"
  alias d='fasd -d'
  alias f='fasd -f'
  alias vf='f -e vim'
fi
