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
