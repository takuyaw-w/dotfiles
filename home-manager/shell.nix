{ ... }:

{
  home.file.".zshrc".source = ../.zshrc;
  home.file.".zshenv".source = ../.zshenv;
  home.file.".zsh" = {
    source = ../.zsh;
    recursive = true;
  };
}
