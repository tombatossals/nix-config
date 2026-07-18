{ pkgs, ... }:

{
  home.packages = with pkgs; [
    walker
    elephant
  ];

  xdg.configFile."walker/config.toml".source = ./config.toml;
}
