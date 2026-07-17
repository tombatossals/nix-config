{ pkgs, ... }:
{
  imports = [
    ./hyprland.nix
    ./ghostty.nix
    ./kitty.nix
    ./foot.nix
    ./waybar
    ./hyprlock
  ];

  home.packages = with pkgs; [

    fuzzel
    mako
    wl-clipboard
  ];
}
