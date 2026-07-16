{ pkgs, ... }:

{
  home.packages = with pkgs; [
    sqlite
    postgresql
    mycli
  ];
}
