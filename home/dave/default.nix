{ ... }:

{
  imports = [
    ../profiles/cli
    ../profiles/dev
    #../profiles/gui
  ];

  xdg.enable = true;

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
