{
  config,
  pkgs,
  lib,
  username ? "dotfiles",
  homeDirectory ? "/home/${username}",
  enableGui ? true,
  ...
}:

let
  browserCommand =
    if enableGui then
      "${pkgs.google-chrome}/bin/google-chrome-stable"
    else
      "/usr/bin/google-chrome-stable";
in
{
  imports = [
    ../nix/packages.nix
  ] ++ lib.optionals enableGui [ ./gui.nix ];

  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "24.05";

  home.file.".zshrc".source = ../.zshrc;
  home.file.".zshenv".source = ../.zshenv;
  home.file.".zsh" = {
    source = ../.zsh;
    recursive = true;
  };
  home.file.".local/bin/wezterm" = {
    executable = true;
    text = ''
      #!/usr/bin/env sh
      set -eu

      if command -v nixGL >/dev/null 2>&1; then
        exec nixGL ${pkgs.wezterm}/bin/wezterm "$@"
      fi

      exec ${pkgs.wezterm}/bin/wezterm "$@"
    '';
  };
  home.file.".local/bin/x-terminal-emulator" = {
    executable = true;
    text = ''
      #!/usr/bin/env sh
      set -eu

      exec "${homeDirectory}/.local/bin/wezterm" "$@"
    '';
  };
  home.file.".local/bin/x-www-browser" = {
    executable = true;
    text = ''
      #!/usr/bin/env sh
      set -eu

      exec ${browserCommand} "$@"
    '';
  };

  xdg.configFile."fcitx5" = {
    source = ../.config/fcitx5;
    recursive = true;
  };
  xdg.configFile."git/config".source = ../.config/git/config;
  xdg.configFile."git/ignore".source = ../.config/git/ignore;
  xdg.configFile."gitui" = {
    source = ../.config/gitui;
    recursive = true;
  };
  xdg.configFile."herdr/config.toml".source = ../.config/herdr/config.toml;
  xdg.configFile."mise/config.toml".source = ../.config/mise/config.toml;
  xdg.configFile."nvim" = {
    source = ../.config/nvim;
    recursive = true;
  };
  xdg.configFile."rofi" = {
    source = ../.config/rofi;
    recursive = true;
  };
  xdg.configFile."sheldon" = {
    source = ../.config/sheldon;
    recursive = true;
  };
  xdg.configFile."wezterm" = {
    source = ../.config/wezterm;
    recursive = true;
  };

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/http" = "google-chrome.desktop";
    "x-scheme-handler/https" = "google-chrome.desktop";
    "text/html" = "google-chrome.desktop";
  };
}
