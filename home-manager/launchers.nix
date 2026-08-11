{
  pkgs,
  lib,
  nixGL,
  enableGui ? true,
  homeDirectory ? "/home/dotfiles",
  ...
}:

let
  nixGLIntel = nixGL.packages.${pkgs.stdenv.hostPlatform.system}.nixGLIntel;
  wrappedWezterm = pkgs.symlinkJoin {
    name = "wezterm-nixgl";
    paths = [ pkgs.wezterm ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      rm -f $out/bin/wezterm
      makeWrapper ${nixGLIntel}/bin/nixGLIntel $out/bin/wezterm \
        --add-flags ${pkgs.wezterm}/bin/wezterm
    '';
  };
  browserCommand =
    if enableGui then
      "${pkgs.google-chrome}/bin/google-chrome-stable"
    else
      "/usr/bin/google-chrome-stable";
in
{
  home.packages = lib.optionals enableGui [ wrappedWezterm ];

  home.file.".local/bin/wezterm" = {
    executable = true;
    text = ''
      #!/usr/bin/env sh
      set -eu

      exec ${wrappedWezterm}/bin/wezterm "$@"
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
