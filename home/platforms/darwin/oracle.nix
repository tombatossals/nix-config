{ pkgs, ... }:

{
  home.packages = with pkgs; [
    oracle-instantclient
  ];
}
