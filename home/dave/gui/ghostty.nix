{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      gtk-titlebar = false;
      theme = "catppuccin-mocha";
    };

  };
}
