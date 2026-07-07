{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bat
    bc
    cmake
    curl
    delta
    deno
    eza
    fd
    fzf
    gcc
    gdb
    gettext
    gh
    ghq
    git
    gitui
    gnumake
    go
    jq
    mise
    neovim
    ripgrep
    rofi
    rustup
    sheldon
    sqlite
    unzip
    wget
    wezterm
    xsel
    zsh
  ];
}
