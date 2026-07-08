{
  pkgs,
  nixGL,
  enableGui ? true,
  homeDirectory ? "/home/dotfiles",
  ...
}:

let
  nixGLIntel = nixGL.packages.${pkgs.stdenv.hostPlatform.system}.nixGLIntel;
  browserCommand =
    if enableGui then
      "${pkgs.google-chrome}/bin/google-chrome-stable"
    else
      "/usr/bin/google-chrome-stable";
in
{
  home.file.".local/bin/wezterm" = {
    executable = true;
    text = ''
      #!/usr/bin/env sh
      set -eu

      exec ${nixGLIntel}/bin/nixGLIntel ${pkgs.wezterm}/bin/wezterm "$@"
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
