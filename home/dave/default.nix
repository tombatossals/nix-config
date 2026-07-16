{ inputs, ... }:

{
  imports = [
    ./cli
    ./dev
    ./gui
  ];

  xdg.enable = true;

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
