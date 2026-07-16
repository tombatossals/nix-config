{ pkgs, ... }:
{
  imports = [
    ./hyprland.nix
    ./waybar
    ./ghostty.nix
    ./kitty.nix
    ./foot.nix
  ];

  home.packages = with pkgs; [
    playerctl
    brightnessctl
    pamixer
    blueman
    wl-clipboard
    cliphist
  ];
}
