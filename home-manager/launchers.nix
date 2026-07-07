{
  pkgs,
  enableGui ? true,
  homeDirectory ? "/home/dotfiles",
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
}
