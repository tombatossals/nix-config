{ config, pkgs, ... }:

{
  xdg.configFile."waybar/colors/gruvbox-material.css".source =
    ./colors/gruvbox-material.css;

  programs.waybar = {
    enable = true;

    systemd.enable = true;

    settings = [
      (builtins.fromJSON (builtins.readFile ./config.jsonc))
    ];

    style = builtins.readFile ./style.css;
  };
}
