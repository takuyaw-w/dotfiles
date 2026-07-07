{ config, pkgs, ... }:

{
  imports = [
    ../nix/packages.nix
    ./gui.nix
  ];

  home.username = "takuya";
  home.homeDirectory = "/home/takuya";
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
}
