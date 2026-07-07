#!/usr/bin/env bash

set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

fail() {
  printf 'not ok - %s\n' "$*" >&2
  exit 1
}

assert_file_contains() {
  local file=$1
  local pattern=$2

  if ! grep -Fq "$pattern" "$file"; then
    printf 'Expected %s to contain: %s\n' "$file" "$pattern" >&2
    printf 'Actual contents:\n' >&2
    cat "$file" >&2
    return 1
  fi
}

test_gitconfig_warns_without_creating_local_config() {
  local home_dir="$tmp_dir/gitconfig-home"
  local output="$tmp_dir/gitconfig.out"
  mkdir -p "$home_dir"

  HOME="$home_dir" \
    bash -c "source '$repo_dir/scripts/lib/gitconfig.sh'" >"$output" </dev/null

  [[ ! -e "$home_dir/.gitconfig.local" ]] || fail ".gitconfig.local was created"
  assert_file_contains "$output" "Git user.name / user.email are not configured."
  assert_file_contains "$output" "Create ~/.gitconfig.local on this machine."
}

test_gitconfig_keeps_existing_local_config() {
  local home_dir="$tmp_dir/existing-gitconfig-home"
  mkdir -p "$home_dir"

  cat >"$home_dir/.gitconfig.local" <<'GITCONFIG'
[user]
    name = Existing User
    email = existing@example.invalid
GITCONFIG

  HOME="$home_dir" bash -c "source '$repo_dir/scripts/lib/gitconfig.sh'" </dev/null

  assert_file_contains "$home_dir/.gitconfig.local" "name = Existing User"
  assert_file_contains "$home_dir/.gitconfig.local" "email = existing@example.invalid"
}

test_home_manager_can_be_skipped_for_smoke_tests() {
  local home_dir="$tmp_dir/home-manager-home"
  mkdir -p "$home_dir"

  HOME="$home_dir" \
    DOTFILES_SKIP_HOME_MANAGER=1 \
    bash -c "source '$repo_dir/scripts/lib/nix-home-manager.sh'; switch_home_manager" </dev/null
}

test_bootstrap_can_run_without_sudo_in_container() {
  local bin_dir="$tmp_dir/fake-bin"
  local command_log="$tmp_dir/bootstrap-commands.log"
  mkdir -p "$bin_dir"

  cat >"$bin_dir/apt-get" <<'SCRIPT'
#!/usr/bin/env bash
printf 'apt-get %s\n' "$*" >>"$COMMAND_LOG"
SCRIPT
  chmod +x "$bin_dir/apt-get"

  PATH="$bin_dir:/usr/bin:/bin" \
    COMMAND_LOG="$command_log" \
    DOTFILES_USE_SUDO=0 \
    bash -c "source '$repo_dir/scripts/lib/utilfuncs.sh'; source '$repo_dir/scripts/lib/bootstrap-ubuntu.sh'; bootstrap_ubuntu" </dev/null

  assert_file_contains "$command_log" "apt-get update"
  assert_file_contains "$command_log" "apt-get install -y ca-certificates curl git passwd sudo xz-utils zsh"
}

test_arch_bootstrap_refreshes_package_database() {
  local bin_dir="$tmp_dir/fake-arch-bin"
  local command_log="$tmp_dir/arch-bootstrap-commands.log"
  mkdir -p "$bin_dir"

  cat >"$bin_dir/pacman" <<'SCRIPT'
#!/usr/bin/env bash
printf 'pacman %s\n' "$*" >>"$COMMAND_LOG"
SCRIPT
  chmod +x "$bin_dir/pacman"

  PATH="$bin_dir:/usr/bin:/bin" \
    COMMAND_LOG="$command_log" \
    DOTFILES_USE_SUDO=0 \
    bash -c "source '$repo_dir/scripts/lib/utilfuncs.sh'; source '$repo_dir/scripts/lib/bootstrap-arch.sh'; bootstrap_arch" </dev/null

  assert_file_contains "$command_log" "pacman -Syu --noconfirm --needed ca-certificates curl git shadow sudo xz zsh"
}

test_install_bootstraps_before_home_manager_setup() {
  local home_dir="$tmp_dir/install-home"
  local bin_dir="$tmp_dir/install-bin"
  local os_release="$tmp_dir/ubuntu-os-release"
  mkdir -p "$home_dir" "$bin_dir"

  cat >"$os_release" <<'EOF_OS_RELEASE'
ID=ubuntu
ID_LIKE=debian
EOF_OS_RELEASE

  cat >"$bin_dir/apt-get" <<'SCRIPT'
#!/usr/bin/env bash
if [[ "$1" == "install" ]]; then
  touch "$GIT_READY_FILE"
fi
SCRIPT
  chmod +x "$bin_dir/apt-get"

  cat >"$bin_dir/git" <<SCRIPT
#!/usr/bin/env bash
if [[ ! -e "\$GIT_READY_FILE" ]]; then
  printf 'git is not available before bootstrap\n' >&2
  exit 127
fi

if [[ "\$*" == "rev-parse --show-toplevel" ]]; then
  printf '%s\n' "$repo_dir"
  exit 0
fi

printf 'unexpected git invocation: %s\n' "\$*" >&2
exit 1
SCRIPT
  chmod +x "$bin_dir/git"

  HOME="$home_dir" \
    PATH="$bin_dir:/usr/bin:/bin" \
    DOTFILES_OS_RELEASE_FILE="$os_release" \
    DOTFILES_SKIP_HOME_MANAGER=1 \
    DOTFILES_USE_SUDO=0 \
    GIT_READY_FILE="$tmp_dir/git-ready" \
    bash "$repo_dir/install.sh" </dev/null

  [[ ! -e "$home_dir/.zshrc" ]] || fail ".zshrc should be managed by Home Manager"
}

test_install_does_not_require_git_for_home_manager_managed_files() {
  local home_dir="$tmp_dir/no-git-files-home"
  local bin_dir="$tmp_dir/no-git-files-bin"
  local os_release="$tmp_dir/no-git-files-os-release"
  mkdir -p "$home_dir" "$bin_dir"

  cat >"$os_release" <<'EOF_OS_RELEASE'
ID=ubuntu
ID_LIKE=debian
EOF_OS_RELEASE

  cat >"$bin_dir/apt-get" <<'SCRIPT'
#!/usr/bin/env bash
exit 0
SCRIPT
  chmod +x "$bin_dir/apt-get"

  cat >"$bin_dir/git" <<'SCRIPT'
#!/usr/bin/env bash
printf 'git must not be required for Home Manager managed files\n' >&2
exit 1
SCRIPT
  chmod +x "$bin_dir/git"

  HOME="$home_dir" \
    PATH="$bin_dir:/usr/bin:/bin" \
    DOTFILES_OS_RELEASE_FILE="$os_release" \
    DOTFILES_SKIP_HOME_MANAGER=1 \
    DOTFILES_USE_SUDO=0 \
    bash "$repo_dir/install.sh" </dev/null

  [[ ! -e "$home_dir/.zshrc" ]] || fail ".zshrc should be managed by Home Manager"
}

test_gitconfig_warns_without_creating_local_config
test_gitconfig_keeps_existing_local_config
test_home_manager_can_be_skipped_for_smoke_tests
test_bootstrap_can_run_without_sudo_in_container
test_arch_bootstrap_refreshes_package_database
test_install_bootstraps_before_home_manager_setup
test_install_does_not_require_git_for_home_manager_managed_files

printf 'ok - installer CI controls\n'
