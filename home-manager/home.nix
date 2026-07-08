{
  config,
  pkgs,
  lib,
  username ? "dotfiles",
  homeDirectory ? "/home/${username}",
  enableGui ? true,
  ...
}:
{
  imports = [
    ../nix/packages.nix
    ./codex.nix
    ./shell.nix
    ./xdg.nix
    ./launchers.nix
  ] ++ lib.optionals enableGui [ ./gui.nix ];

  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "24.05";
}
