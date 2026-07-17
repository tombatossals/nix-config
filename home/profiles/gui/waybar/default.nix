{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    systemd.enable = true;

    settings = [
      (builtins.fromJSON (builtins.readFile ./config.jsonc))
    ];

    style = builtins.readFile ./style.css;
  };
}
