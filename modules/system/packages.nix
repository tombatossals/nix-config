modules/system/packages.nix
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ghostty.terminfo
  ];
}
