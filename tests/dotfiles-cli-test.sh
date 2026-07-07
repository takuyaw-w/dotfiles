#!/usr/bin/env bash

set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT
bash_bin=${BASH:-bash}
test_command_path="$(dirname "$bash_bin"):$PATH"

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

  "$bash_bin" "$repo_dir/dotfiles.sh" help >"$output"

  assert_file_contains "$output" "Usage:"
  assert_file_contains "$output" "doctor"
  assert_file_contains "$output" "bootstrap"
  assert_file_contains "$output" "switch"
  assert_file_contains "$output" "install"
  assert_file_contains "$output" "desktop"
  assert_file_contains "$output" "update"
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

  cat >"$bin_dir/apt-get" <<SCRIPT
#!$bash_bin
printf 'apt-get %s\n' "\$*" >>"\$COMMAND_LOG"
SCRIPT
  chmod +x "$bin_dir/apt-get"

  HOME="$home_dir" \
    PATH="$bin_dir:$test_command_path" \
    COMMAND_LOG="$command_log" \
    DOTFILES_OS_RELEASE_FILE="$os_release" \
    DOTFILES_SKIP_HOME_MANAGER=1 \
    DOTFILES_USE_SUDO=0 \
    "$bash_bin" "$repo_dir/dotfiles.sh" install >"$output" </dev/null

  assert_file_contains "$command_log" "apt-get update"
  [[ ! -e "$home_dir/.zshrc" ]] || fail ".zshrc should be managed by Home Manager"
  [[ ! -e "$home_dir/.config/git" ]] || fail ".config/git should be managed by Home Manager"
  [[ ! -e "$home_dir/.gitconfig.local" ]] || fail ".gitconfig.local was created"
  assert_file_contains "$output" "Git user.name / user.email are not configured."
  assert_file_contains "$output" "Skip Home Manager switch because DOTFILES_SKIP_HOME_MANAGER=1."
  assert_file_contains "$output" "Run ~/.dotfiles/dotfiles.sh desktop"
}

test_doctor_prints_next_steps_for_missing_prerequisites() {
  local home_dir="$tmp_dir/doctor-home"
  local bin_dir="$tmp_dir/doctor-bin"
  local os_release="$tmp_dir/doctor-os-release"
  local output="$tmp_dir/doctor.out"
  mkdir -p "$home_dir" "$bin_dir"

  cat >"$os_release" <<'EOF_OS_RELEASE'
ID=ubuntu
ID_LIKE=debian
EOF_OS_RELEASE

  cat >"$bin_dir/nix" <<SCRIPT
#!$bash_bin
exit 0
SCRIPT
  chmod +x "$bin_dir/nix"

  HOME="$home_dir" \
    PATH="$bin_dir:$(dirname "$bash_bin"):$(dirname "$(command -v dirname)"):$(dirname "$(command -v awk)")" \
    DOTFILES_OS_RELEASE_FILE="$os_release" \
    "$bash_bin" "$repo_dir/dotfiles.sh" doctor >"$output" </dev/null

  assert_file_contains "$output" "Git identity: missing ~/.gitconfig.local"
  assert_file_contains "$output" "Home Manager: not found"
  assert_file_contains "$output" "Next steps:"
  assert_file_contains "$output" "Create ~/.gitconfig.local on this machine."
  assert_file_contains "$output" "nix profile install github:nix-community/home-manager"
  assert_file_contains "$output" "~/.dotfiles/dotfiles.sh install"
}

test_install_sh_entrypoint_is_removed() {
  [[ ! -e "$repo_dir/install.sh" ]] || fail "install.sh should be removed to avoid duplicate setup entrypoints"
}

test_link_command_is_removed() {
  local output="$tmp_dir/link-removed.out"

  if "$bash_bin" "$repo_dir/dotfiles.sh" link >"$output" 2>&1; then
    fail "link command should be removed"
  fi

  assert_file_contains "$output" "Usage:"
  assert_file_not_contains "$output" "link"
}

test_readme_starts_setup_with_doctor() {
  assert_file_contains "$repo_dir/README.md" "git clone https://github.com/takuyaw-w/dotfiles.git ~/.dotfiles"
  assert_file_contains "$repo_dir/README.md" "~/.dotfiles/dotfiles.sh doctor"
  assert_file_contains "$repo_dir/README.md" "sh <(curl -L https://nixos.org/nix/install) --daemon"
  assert_file_contains "$repo_dir/README.md" "nix profile install github:nix-community/home-manager"
  assert_file_contains "$repo_dir/README.md" "cat >~/.gitconfig.local <<'GITCONFIG'"
  assert_file_contains "$repo_dir/README.md" "~/.dotfiles/dotfiles.sh install"
  assert_file_not_contains "$repo_dir/README.md" "まず現在のマシンを確認する。"
  assert_file_not_contains "$repo_dir/README.md" "推奨 CLI / 前提を入れたら、もう一度 install を実行する。"
  assert_file_not_contains "$repo_dir/README.md" "./install.sh"
}

test_home_manager_manages_git_and_shell_files() {
  assert_file_contains "$repo_dir/flake.nix" "./home-manager/home.nix"
  assert_file_contains "$repo_dir/home-manager/home.nix" "../nix/packages.nix"
  assert_file_contains "$repo_dir/home-manager/home.nix" "./gui.nix"
  assert_file_contains "$repo_dir/home-manager/home.nix" "./shell.nix"
  assert_file_contains "$repo_dir/home-manager/home.nix" "./xdg.nix"
  assert_file_contains "$repo_dir/home-manager/home.nix" "./launchers.nix"
  assert_file_not_contains "$repo_dir/home-manager/home.nix" "./git.nix"
  assert_file_not_contains "$repo_dir/home-manager/home.nix" "programs.home-manager.enable"
  [[ ! -e "$repo_dir/home-manager/git.nix" ]] || fail "git.nix should not manage git config"
  assert_file_contains "$repo_dir/home-manager/xdg.nix" 'xdg.configFile."git/config"'
  assert_file_contains "$repo_dir/home-manager/xdg.nix" "source = ../.config/git/config;"
  assert_file_contains "$repo_dir/.config/git/config" "path = ~/.gitconfig.local"
  assert_file_not_contains "$repo_dir/.config/git/config" "git-credential-libsecret"
  assert_file_contains "$repo_dir/.config/git/config" '[credential "https://github.com"]'
  assert_file_contains "$repo_dir/.config/git/config" "helper = !/usr/bin/gh auth git-credential"
  assert_file_contains "$repo_dir/home-manager/shell.nix" 'home.file.".zshrc".source'
  assert_file_contains "$repo_dir/home-manager/shell.nix" 'home.file.".zshenv".source'
  assert_file_contains "$repo_dir/home-manager/shell.nix" 'home.file.".zsh"'
  assert_file_contains "$repo_dir/home-manager/shell.nix" "source = ../.zsh;"
  assert_file_contains "$repo_dir/home-manager/xdg.nix" 'xdg.configFile."nvim"'
  assert_file_contains "$repo_dir/home-manager/xdg.nix" "source = ../.config/nvim;"
}

test_flake_exposes_test_profile_and_checks() {
  assert_file_contains "$repo_dir/flake.nix" "profiles = {"
  assert_file_contains "$repo_dir/flake.nix" "desktop-x86_64-linux ="
  assert_file_contains "$repo_dir/flake.nix" "desktop-aarch64-linux ="
  assert_file_contains "$repo_dir/flake.nix" "NIX_USERNAME"
  assert_file_contains "$repo_dir/flake.nix" "NIX_HOME_DIRECTORY"
  assert_file_contains "$repo_dir/flake.nix" "test ="
  assert_file_contains "$repo_dir/flake.nix" 'username = "test";'
  assert_file_contains "$repo_dir/flake.nix" 'homeDirectory = "/home/test";'
  assert_file_contains "$repo_dir/flake.nix" "enableGui = false;"
  assert_file_contains "$repo_dir/flake.nix" "checks = forAllSystems"
  assert_file_contains "$repo_dir/flake.nix" "home-activation"
  assert_file_contains "$repo_dir/flake.nix" "shell-tests"
}

test_home_manager_switch_uses_generic_profile_and_runtime_user() {
  assert_file_contains "$repo_dir/scripts/lib/nix-home-manager.sh" "DOTFILES_HOME_MANAGER_PROFILE"
  assert_file_contains "$repo_dir/scripts/lib/nix-home-manager.sh" "desktop-\${system}"
  assert_file_contains "$repo_dir/scripts/lib/nix-home-manager.sh" "NIX_USERNAME"
  assert_file_contains "$repo_dir/scripts/lib/nix-home-manager.sh" "NIX_HOME_DIRECTORY"
  assert_file_contains "$repo_dir/scripts/lib/nix-home-manager.sh" "switch --impure --flake"
  assert_file_not_contains "$repo_dir/scripts/lib/nix-home-manager.sh" "takuya-"
  assert_file_not_contains "$repo_dir/home-manager/home.nix" 'username ? "takuya"'
}

test_github_actions_run_flake_check_and_manual_home_manager_switch() {
  local workflow="$repo_dir/.github/workflows/distro-smoke.yml"

  assert_file_contains "$workflow" "name: Nix flake check"
  assert_file_contains "$workflow" "nix flake check"
  assert_file_contains "$workflow" "home-manager-switch"
  assert_file_contains "$workflow" "if: github.event_name == 'workflow_dispatch'"
  assert_file_contains "$workflow" "ubuntu:latest"
  assert_file_contains "$workflow" "fedora:latest"
  assert_file_contains "$workflow" "home-manager switch --flake .#test"
}

test_zshrc_autostarts_herdr_for_local_interactive_terminals() {
  assert_file_contains "$repo_dir/.zshrc" "HERDR_AUTO_START"
  assert_file_contains "$repo_dir/.zshrc" "HERDR_SOCKET_PATH"
  assert_file_contains "$repo_dir/.zshrc" "SSH_CONNECTION"
  assert_file_contains "$repo_dir/.zshrc" "builtin command -v herdr"
  assert_file_contains "$repo_dir/.zshrc" "exec herdr"
}

test_zshenv_prefers_mise_shims_for_tool_commands() {
  local mise_shims_line
  local local_bin_line
  local inherited_path_line

  assert_file_contains "$repo_dir/.zshenv" '$HOME/.local/share/mise/shims(N-/)'
  assert_file_contains "$repo_dir/.zshenv" '$HOME/.local/bin(N-/)'
  assert_file_contains "$repo_dir/.zshenv" '  $path'

  mise_shims_line=$(grep -nF '  $HOME/.local/share/mise/shims(N-/)' "$repo_dir/.zshenv" | cut -d: -f1)
  local_bin_line=$(grep -nF '  $HOME/.local/bin(N-/)' "$repo_dir/.zshenv" | cut -d: -f1)
  inherited_path_line=$(grep -nF '  $path' "$repo_dir/.zshenv" | cut -d: -f1)

  [[ -n "$mise_shims_line" ]] || fail "mise shims path entry was not found"
  [[ -n "$local_bin_line" ]] || fail ".local/bin path entry was not found"
  [[ -n "$inherited_path_line" ]] || fail "inherited path entry was not found"
  ((mise_shims_line < local_bin_line)) || fail "mise shims should precede .local/bin"
  ((mise_shims_line < inherited_path_line)) || fail "mise shims should precede inherited path"
}

test_home_manager_manages_mise_config() {
  assert_file_contains "$repo_dir/home-manager/xdg.nix" 'xdg.configFile."mise/config.toml"'
  assert_file_contains "$repo_dir/home-manager/xdg.nix" "source = ../.config/mise/config.toml;"
  assert_file_contains "$repo_dir/.config/mise/config.toml" '[tools."npm:@openai/codex"]'
  assert_file_contains "$repo_dir/.config/mise/config.toml" 'minimum_release_age = "0s"'
}

test_home_manager_manages_herdr_config_and_mimeapps() {
  assert_file_contains "$repo_dir/home-manager/xdg.nix" 'xdg.configFile."herdr/config.toml"'
  assert_file_contains "$repo_dir/home-manager/xdg.nix" "source = ../.config/herdr/config.toml;"
  assert_file_contains "$repo_dir/.config/herdr/config.toml" '[terminal]'
  assert_file_contains "$repo_dir/.config/herdr/config.toml" 'shell_mode = "non_login"'
  assert_file_contains "$repo_dir/home-manager/xdg.nix" "xdg.mimeApps.enable = true;"
  assert_file_contains "$repo_dir/home-manager/xdg.nix" '"x-scheme-handler/http" = "google-chrome.desktop";'
  assert_file_contains "$repo_dir/home-manager/xdg.nix" '"x-scheme-handler/https" = "google-chrome.desktop";'
  assert_file_contains "$repo_dir/home-manager/xdg.nix" '"text/html" = "google-chrome.desktop";'
}

test_wezterm_uses_home_manager_nixgl_wrapper_not_shell_alias() {
  assert_file_not_contains "$repo_dir/.zsh/rc/alias.zsh" "alias wezterm="
  assert_file_contains "$repo_dir/home-manager/launchers.nix" 'home.file.".local/bin/wezterm"'
  assert_file_contains "$repo_dir/home-manager/launchers.nix" "nixGL"
  assert_file_contains "$repo_dir/home-manager/launchers.nix" "\${pkgs.wezterm}/bin/wezterm"
  assert_file_contains "$repo_dir/home-manager/launchers.nix" 'home.file.".local/bin/x-terminal-emulator"'
  assert_file_contains "$repo_dir/home-manager/launchers.nix" 'home.file.".local/bin/x-www-browser"'
  assert_file_contains "$repo_dir/home-manager/launchers.nix" '.local/bin/wezterm'
  assert_file_contains "$repo_dir/home-manager/launchers.nix" "google-chrome-stable"
}

test_update_command_runs_flake_update_then_check() {
  local bin_dir="$tmp_dir/update-bin"
  local command_log="$tmp_dir/update-commands.log"
  local output="$tmp_dir/update.out"
  mkdir -p "$bin_dir"

  cat >"$bin_dir/nix" <<SCRIPT
#!$bash_bin
printf 'nix %s\n' "\$*" >>"\$COMMAND_LOG"
SCRIPT
  chmod +x "$bin_dir/nix"

  HOME="$tmp_dir/update-home" \
    PATH="$bin_dir:$test_command_path" \
    COMMAND_LOG="$command_log" \
    "$bash_bin" "$repo_dir/dotfiles.sh" update >"$output" </dev/null

  assert_file_contains "$command_log" "nix flake update"
  assert_file_contains "$command_log" "nix flake check"
  assert_file_contains "$output" "Update flake.lock"
  assert_file_contains "$output" "flake.lock update is done."
  assert_file_not_contains "$repo_dir/scripts/lib/flake-update.sh" "git -C"
}

test_readme_documents_profiles_and_flake_lock_update() {
  assert_file_contains "$repo_dir/README.md" "desktop-x86_64-linux"
  assert_file_contains "$repo_dir/README.md" "DOTFILES_HOME_MANAGER_PROFILE"
  assert_file_contains "$repo_dir/README.md" "NIX_USERNAME"
  assert_file_contains "$repo_dir/README.md" "NIX_HOME_DIRECTORY"
  assert_file_contains "$repo_dir/README.md" "test profile"
  assert_file_contains "$repo_dir/README.md" "dotfiles.sh update"
  assert_file_contains "$repo_dir/README.md" "nix flake update"
  assert_file_contains "$repo_dir/README.md" "nix flake check"
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
test_doctor_prints_next_steps_for_missing_prerequisites
test_install_sh_entrypoint_is_removed
test_link_command_is_removed
test_readme_starts_setup_with_doctor
test_home_manager_manages_git_and_shell_files
test_flake_exposes_test_profile_and_checks
test_home_manager_switch_uses_generic_profile_and_runtime_user
test_github_actions_run_flake_check_and_manual_home_manager_switch
test_zshrc_autostarts_herdr_for_local_interactive_terminals
test_zshenv_prefers_mise_shims_for_tool_commands
test_home_manager_manages_mise_config
test_home_manager_manages_herdr_config_and_mimeapps
test_wezterm_uses_home_manager_nixgl_wrapper_not_shell_alias
test_home_manager_manages_gui_apps
test_home_manager_manages_local_tools
test_update_command_runs_flake_update_then_check
test_readme_documents_profiles_and_flake_lock_update

printf 'ok - dotfiles cli\n'
