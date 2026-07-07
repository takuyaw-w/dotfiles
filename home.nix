{ config, pkgs, ... }:

{
  imports = [
    ./nix/packages.nix
    ./nix/home/git.nix
    ./nix/home/zsh.nix
  ];

  home.username = "takuya";
  home.homeDirectory = "/home/takuya";
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
