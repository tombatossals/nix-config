{ ... }:

{
  imports = [
    ../profiles/cli
    ../profiles/dev
    #../profiles/gui
  ];

  home.username = "dave";

  xdg.enable = true;

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
