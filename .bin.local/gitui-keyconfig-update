#!/usr/bin/env bash

readonly TARGET_URL="https://raw.githubusercontent.com/extrawurst/gitui/master/vim_style_key_config.ron"
readonly TMP_DIR="/tmp"
readonly TMP_FILE_NAME="tmp_keyconfig.ron"
readonly TMP_KEYCONFIG_FILE="$TMP_DIR/$TMP_FILE_NAME"
readonly DOT_FILES_DIR=".dotfiles"
readonly DOT_CONFIG_DIR=".config"
readonly GITUI_DIR="gitui"
readonly KEYCONFIG_FILE="key_config.ron"
readonly TARGET_KEYCONFIG_FILE="$HOME/$DOT_FILES_DIR/$DOT_CONFIG_DIR/$GITUI_DIR/$KEYCONFIG_FILE"

# キーコンフィグファイルをダウンロードする
function fetch_keyconfig_file() {
  curl -# -o $TMP_KEYCONFIG_FILE $TARGET_URL
}
# 差分を検出する
function differencial_detection() {
  diff -s $TMP_KEYCONFIG_FILE $TARGET_KEYCONFIG_FILE >/dev/null 2>&1
}
# コピーを行う
function overwrite_original_file() {
  \cp -f $TMP_KEYCONFIG_FILE $TARGET_KEYCONFIG_FILE
}

function main() {
  fetch_keyconfig_file
  if [[ $? -ne 0 ]]; then
    echo "Download Error."
    exit 1
  fi

  differencial_detection
  case $? in
    0)
      echo "No changes."
      ;;
    1)
      overwrite_original_file
      echo "Updated."
      ;;
    2)
      echo "error."
      ;;
  esac
}

main
