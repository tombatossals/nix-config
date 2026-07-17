{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nginx
  ];
}
