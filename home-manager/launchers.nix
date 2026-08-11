{
  pkgs,
  lib,
  enableGui ? true,
  homeDirectory ? "/home/dotfiles",
  ...
}:

let
  weztermStableAppImage = pkgs.fetchurl {
    url = "https://github.com/wez/wezterm/releases/download/20240203-110809-5046fc22/WezTerm-20240203-110809-5046fc22-Ubuntu20.04.AppImage";
    hash = "sha256-VT04IKEudclE2ioBkLvGx56Uu/waBtrTN5hq8YDE5d0=";
    executable = true;
  };
  weztermStable = pkgs.writeShellScriptBin "wezterm" ''
    exec ${weztermStableAppImage} "$@"
  '';
  browserCommand =
    if enableGui then
      "${pkgs.google-chrome}/bin/google-chrome-stable"
    else
      "/usr/bin/google-chrome-stable";
in
{
  home.packages = lib.optionals enableGui [ weztermStable ];

  home.file.".local/bin/wezterm" = {
    executable = true;
    text = ''
      #!/usr/bin/env sh
      set -eu

      exec ${weztermStable}/bin/wezterm "$@"
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
}
