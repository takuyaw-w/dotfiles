#!/usr/bin/env bash

function os_release_file() {
  echo "${DOTFILES_OS_RELEASE_FILE:-/etc/os-release}"
}

function os_release_value() {
  local key=$1
  local file
  file=$(os_release_file)

  if [[ ! -r "$file" ]]; then
    return 1
  fi

  awk -F= -v key="$key" '
    $1 == key {
      value=$2
      gsub(/^"/, "", value)
      gsub(/"$/, "", value)
      print value
      exit
    }
  ' "$file"
}

function detect_distro_family() {
  local id
  local id_like
  id=$(os_release_value ID || true)
  id_like=$(os_release_value ID_LIKE || true)

  case "$id" in
    arch|manjaro)
      echo "arch"
      return 0
      ;;
    ubuntu)
      echo "ubuntu"
      return 0
      ;;
    fedora)
      echo "fedora"
      return 0
      ;;
  esac

  case " $id_like " in
    *" arch "*)
      echo "arch"
      return 0
      ;;
    *" debian "*)
      if [[ "$id" == "ubuntu" ]]; then
        echo "ubuntu"
        return 0
      fi
      ;;
    *" fedora "*)
      echo "fedora"
      return 0
      ;;
  esac

  echo "Unsupported Linux distribution: ID=${id:-unknown} ID_LIKE=${id_like:-unknown}" >&2
  return 1
}
