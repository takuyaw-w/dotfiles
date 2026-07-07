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

assert_file_not_contains() {
  local file=$1
  local pattern=$2

  if grep -Fq "$pattern" "$file"; then
    printf 'Expected %s not to contain: %s\n' "$file" "$pattern" >&2
    printf 'Actual contents:\n' >&2
    cat "$file" >&2
    return 1
  fi
}

test_help_lists_subcommands() {
  local output="$tmp_dir/help.out"

  "$repo_dir/dotfiles.sh" help >"$output"

  assert_file_contains "$output" "Usage:"
  assert_file_contains "$output" "doctor"
  assert_file_contains "$output" "bootstrap"
  assert_file_contains "$output" "switch"
  assert_file_contains "$output" "install"
  assert_file_contains "$output" "desktop"
  assert_file_not_contains "$output" "link"
}

test_install_runs_bootstrap_gitconfig_and_switch() {
  local home_dir="$tmp_dir/dotfiles-install-home"
  local bin_dir="$tmp_dir/fake-bin"
  local os_release="$tmp_dir/ubuntu-os-release"
  local command_log="$tmp_dir/dotfiles-install-commands.log"
  local output="$tmp_dir/dotfiles-install.out"
  mkdir -p "$home_dir" "$bin_dir"

  cat >"$os_release" <<'EOF_OS_RELEASE'
ID=ubuntu
ID_LIKE=debian
EOF_OS_RELEASE

  cat >"$bin_dir/apt-get" <<'SCRIPT'
#!/usr/bin/env bash
printf 'apt-get %s\n' "$*" >>"$COMMAND_LOG"
SCRIPT
  chmod +x "$bin_dir/apt-get"

  HOME="$home_dir" \
    PATH="$bin_dir:/usr/bin:/bin" \
    COMMAND_LOG="$command_log" \
    DOTFILES_OS_RELEASE_FILE="$os_release" \
    DOTFILES_SKIP_HOME_MANAGER=1 \
    DOTFILES_USE_SUDO=0 \
    "$repo_dir/dotfiles.sh" install >"$output" </dev/null

  assert_file_contains "$command_log" "apt-get update"
  [[ ! -e "$home_dir/.zshrc" ]] || fail ".zshrc should be managed by Home Manager"
  [[ ! -e "$home_dir/.config/git" ]] || fail ".config/git should be managed by Home Manager"
  [[ ! -e "$home_dir/.gitconfig.local" ]] || fail ".gitconfig.local was created"
  assert_file_contains "$output" "Git user.name / user.email are not configured."
  assert_file_contains "$output" "Skip Home Manager switch because DOTFILES_SKIP_HOME_MANAGER=1."
  assert_file_contains "$output" "Run ~/.dotfiles/dotfiles.sh desktop"
}

test_install_sh_delegates_to_dotfiles_install() {
  local home_dir="$tmp_dir/install-home"
  local bin_dir="$tmp_dir/install-bin"
  local os_release="$tmp_dir/install-os-release"
  local command_log="$tmp_dir/install-commands.log"
  local output="$tmp_dir/install.out"
  mkdir -p "$home_dir" "$bin_dir"

  cat >"$os_release" <<'EOF_OS_RELEASE'
ID=ubuntu
ID_LIKE=debian
EOF_OS_RELEASE

  cat >"$bin_dir/apt-get" <<'SCRIPT'
#!/usr/bin/env bash
printf 'apt-get %s\n' "$*" >>"$COMMAND_LOG"
SCRIPT
  chmod +x "$bin_dir/apt-get"

  HOME="$home_dir" \
    PATH="$bin_dir:/usr/bin:/bin" \
    COMMAND_LOG="$command_log" \
    DOTFILES_OS_RELEASE_FILE="$os_release" \
    DOTFILES_SKIP_HOME_MANAGER=1 \
    DOTFILES_USE_SUDO=0 \
    "$repo_dir/install.sh" >"$output" </dev/null

  assert_file_contains "$output" "install.sh is a convenience wrapper."
  assert_file_contains "$output" "For explicit setup, run:"
  assert_file_contains "$output" "~/.dotfiles/dotfiles.sh doctor"
  [[ ! -e "$home_dir/.zshrc" ]] || fail ".zshrc should be managed by Home Manager"
}

test_link_command_is_removed() {
  local output="$tmp_dir/link-removed.out"

  if "$repo_dir/dotfiles.sh" link >"$output" 2>&1; then
    fail "link command should be removed"
  fi

  assert_file_contains "$output" "Usage:"
  assert_file_not_contains "$output" "link"
}

test_home_manager_manages_git_and_shell_files() {
  assert_file_contains "$repo_dir/flake.nix" "./home-manager/home.nix"
  assert_file_contains "$repo_dir/home-manager/home.nix" "../nix/packages.nix"
  assert_file_contains "$repo_dir/home-manager/home.nix" "./gui.nix"
  assert_file_not_contains "$repo_dir/home-manager/home.nix" "./git.nix"
  assert_file_not_contains "$repo_dir/home-manager/home.nix" "programs.home-manager.enable"
  [[ ! -e "$repo_dir/home-manager/git.nix" ]] || fail "git.nix should not manage git config"
  assert_file_contains "$repo_dir/home-manager/home.nix" 'xdg.configFile."git/config"'
  assert_file_contains "$repo_dir/home-manager/home.nix" "source = ../.config/git/config;"
  assert_file_contains "$repo_dir/.config/git/config" "path = ~/.gitconfig.local"
  assert_file_not_contains "$repo_dir/.config/git/config" "git-credential-libsecret"
  assert_file_contains "$repo_dir/.config/git/config" '[credential "https://github.com"]'
  assert_file_contains "$repo_dir/.config/git/config" "helper = !/usr/bin/gh auth git-credential"
  assert_file_contains "$repo_dir/home-manager/home.nix" 'home.file.".zshrc".source'
  assert_file_contains "$repo_dir/home-manager/home.nix" 'home.file.".zshenv".source'
  assert_file_contains "$repo_dir/home-manager/home.nix" 'home.file.".zsh"'
  assert_file_contains "$repo_dir/home-manager/home.nix" "source = ../.zsh;"
  assert_file_contains "$repo_dir/home-manager/home.nix" 'xdg.configFile."nvim"'
  assert_file_contains "$repo_dir/home-manager/home.nix" "source = ../.config/nvim;"
}

test_zshrc_autostarts_herdr_for_local_interactive_terminals() {
  assert_file_contains "$repo_dir/.zshrc" "HERDR_AUTO_START"
  assert_file_contains "$repo_dir/.zshrc" "HERDR_SOCKET_PATH"
  assert_file_contains "$repo_dir/.zshrc" "SSH_CONNECTION"
  assert_file_contains "$repo_dir/.zshrc" "builtin command -v herdr"
  assert_file_contains "$repo_dir/.zshrc" "exec herdr"
}

test_home_manager_manages_gui_apps() {
  assert_file_contains "$repo_dir/home-manager/gui.nix" "google-chrome"
  assert_file_contains "$repo_dir/home-manager/gui.nix" "vscode"
}

test_home_manager_manages_local_tools() {
  assert_file_contains "$repo_dir/flake.nix" "github:modem-dev/hunk"
  assert_file_contains "$repo_dir/nix/packages.nix" "herdr"
  assert_file_contains "$repo_dir/nix/packages.nix" "hunk.packages"
}

test_help_lists_subcommands
test_install_runs_bootstrap_gitconfig_and_switch
test_install_sh_delegates_to_dotfiles_install
test_link_command_is_removed
test_home_manager_manages_git_and_shell_files
test_zshrc_autostarts_herdr_for_local_interactive_terminals
test_home_manager_manages_gui_apps
test_home_manager_manages_local_tools

printf 'ok - dotfiles cli\n'
