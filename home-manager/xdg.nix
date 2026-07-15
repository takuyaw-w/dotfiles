{ ... }:

{
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
  xdg.configFile."hunk/config.toml".source = ../.config/hunk/config.toml;
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
