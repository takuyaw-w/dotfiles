#!/usr/bin/env bash

set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
docker_bin=${DOTFILES_DOCKER_BIN:-docker}
distros=(ubuntu fedora manjaro)

usage() {
  cat >&2 <<USAGE
Usage: $0 <ubuntu|fedora|manjaro|all>
USAGE
}

run_distro() {
  local distro=$1
  local dockerfile="$repo_dir/tests/docker/${distro}.Dockerfile"
  local image="dotfiles-smoke:${distro}"

  "$docker_bin" build --file "$dockerfile" --tag "$image" "$repo_dir"
  "$docker_bin" run --rm --volume "$repo_dir:/workspace:ro" "$image"
}

case "${1:-}" in
  ubuntu|fedora|manjaro)
    run_distro "$1"
    ;;
  all)
    for distro in "${distros[@]}"; do
      run_distro "$distro"
    done
    ;;
  *)
    usage
    exit 2
    ;;
esac
