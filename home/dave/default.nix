{ ... }:

{
  imports = [
    ../profiles/cli
    ../profiles/dev
    ../profiles/ops
    #../profiles/gui
  ];

  xdg.enable = true;

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
