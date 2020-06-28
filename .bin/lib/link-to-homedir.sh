#!/bin/env bash

set -ue

source $(dirname "${BASH_SOURCE[0]:-$0}")/utilfuncs.sh

function backup_and_link() {
  local link_src_file=$1
  local link_dest_dir=$2
  local backupdir=$3
  local f_filename
  f_filename=$(basename "$link_src_file")
  local f_filepath="$link_dest_dir/$f_filename"
  if [[ -L "$f_filepath" ]]; then
    command rm -f "$f_filepath"
  fi

  local file_list
  file_list=$(command find "$link_src_file" -name "_install.sh" -type f 2> /dev/null)
  if [[ -n "$file_list" ]]; then
    if [[ -e "$f_filepath" ]]; then
      command cp -r "$f_filepath" "$backupdir"
    fi
    for f in $file_list; do
      eval "$f"
    done
    return
  fi
  if [[ -e "$f_filepath" && ! -L "$f_filepath" ]]; then
    command mv "$f_filepath" "$backupdir"
  fi
  command ln -snf "$link_src_file" "$link_dest_dir"
}

function link_config_dir() {
  local backupdir="$HOME/.dotbackup/.config"
  mkdir_not_exist "$backupdir"
  local dest_dir="${HOME}/.config"
  mkdir_not_exist "$dest_dir"

  local dotfiles_dir=$1
  for f in "$dotfiles_dir"/.config/??*; do
    backup_and_link "$f" "$dest_dir" "$backupdir"
  done
}

function link_to_homedir() {
  local tmp_date
  tmp_date=$(date '+%Y%m%d_%H%M%S')
  local backupdir="$HOME/.dotbackup/$tmp_date"
  mkdir_not_exist "$backupdir"

  local current_dir
  current_dir=$(dirname "${BASH_SOURCE[0]:-$0}")
  local dotfiles_dir
  dotfiles_dir="$(builtin cd "$current_dir" && git rev-parse --show-toplevel)"
  if [[ "$HOME" != "$dotfiles_dir" ]]; then
    for f in "$dotfiles_dir"/.??*; do
      local f_filename
      f_filename=$(basename "$f")
      [[ "$f_filename" == ".editorconfig" ]] && continue
      [[ "$f_filename" == ".config" ]] && link_config_dir "$dotfiles_dir" && continue
      backup_and_link "$f" "$HOME" "$backupdir"
    done
  fi
}

info_message "Start link to homedir."

link_to_homedir

complete_message "Link to homedir done."
