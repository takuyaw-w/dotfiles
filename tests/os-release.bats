#!/usr/bin/env bats

load_os_release() {
  local fixture="$BATS_TEST_DIRNAME/os-release/$1.env"
  local library="$BATS_TEST_DIRNAME/../.bin/lib/os-release.sh"

  DOTFILES_OS_RELEASE_FILE="$fixture" \
    bash -c 'source "$1"; detect_distro_family' bash "$library"
}

@test "detects arch fixture" {
  run load_os_release arch
  [ "$status" -eq 0 ]
  [ "$output" = "arch" ]
}

@test "detects manjaro fixture as arch family" {
  run load_os_release manjaro
  [ "$status" -eq 0 ]
  [ "$output" = "arch" ]
}

@test "detects ubuntu fixture" {
  run load_os_release ubuntu
  [ "$status" -eq 0 ]
  [ "$output" = "ubuntu" ]
}

@test "detects fedora fixture" {
  run load_os_release fedora
  [ "$status" -eq 0 ]
  [ "$output" = "fedora" ]
}

@test "rejects unsupported distro" {
  run load_os_release unsupported
  [ "$status" -eq 1 ]
  [[ "$output" == *"Unsupported Linux distribution"* ]]
}
