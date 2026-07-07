#!/usr/bin/env bash

set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

fake_docker="$tmp_dir/docker"
docker_log="$tmp_dir/docker.log"

cat >"$fake_docker" <<'SCRIPT'
#!/usr/bin/env bash
printf '%s\n' "$*" >>"$DOCKER_LOG"
SCRIPT
chmod +x "$fake_docker"

DOTFILES_DOCKER_BIN="$fake_docker" \
  DOCKER_LOG="$docker_log" \
  "$repo_dir/tests/docker/run.sh" ubuntu

grep -Fq "build --file $repo_dir/tests/docker/ubuntu.Dockerfile --tag dotfiles-smoke:ubuntu $repo_dir" "$docker_log"
grep -Fq "run --rm --volume $repo_dir:/workspace:ro dotfiles-smoke:ubuntu" "$docker_log"

if "$repo_dir/tests/docker/run.sh" unsupported >"$tmp_dir/unsupported.out" 2>"$tmp_dir/unsupported.err"; then
  printf 'unsupported distro unexpectedly succeeded\n' >&2
  exit 1
fi

grep -Fq "Usage:" "$tmp_dir/unsupported.err"

printf 'ok - docker runner\n'
