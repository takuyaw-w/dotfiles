#!/usr/bin/env bash

function print_default() {
  echo -e "$*"
}

function print_info() {
  echo -e "\e[1;36m$*\e[m" # cyan
}

function print_notice() {
  echo -e "\e[1;35m$*\e[m" # magenta
}

function print_success() {
  echo -e "\e[1;32m$*\e[m" # green
}

function print_warning() {
  echo -e "\e[1;33m$*\e[m" # yellow
}

function print_error() {
  echo -e "\e[1;31m$*\e[m" # red
}

function print_debug() {
  echo -e "\e[1;34m$*\e[m" # blue
}

function info_message() {
  print_info ""
  print_info ""
  print_info "( =_=)...$*"
  print_info ""
  print_info ""

  delay
}

function complete_message() {
  print_success ""
  print_success ""
  print_success "( =_=)...$*"
  print_success ""
  print_success ""

  delay
}

function chkcmd() {
  if ! builtin command -v "$1";then
    print_error "${1} command not found"
    exit
  fi
}

function mkdir_not_exist() {
  if [ ! -d "$1" ];then
    mkdir -p "$1"
  fi
}

function delay() {
  sleep 0.03
}
