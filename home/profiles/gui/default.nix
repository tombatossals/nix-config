{ pkgs, ... }:
{
  imports = [
    ./apps
    ./wallpaper
    ./hyprland.nix
    ./ghostty.nix
    ./kitty.nix
    ./foot.nix
    ./waybar
    ./walker
    ./hyprlock
    ./swaynotificationcenter
  ];

  home.packages = with pkgs; [

    fuzzel
    mako
    wl-clipboard
  ];
}
