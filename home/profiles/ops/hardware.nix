{ pkgs, ... }:

{
  home.packages = with pkgs; [
    smartmontools # smartctl: salud de los discos
  ];
}
