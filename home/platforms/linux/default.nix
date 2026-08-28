{ pkgs, ... }:

{
  imports = [
    ./terminfo.nix
  ];

  home.packages = with pkgs; [
    pciutils # lspci
    sshfs # montar directorios remotos por SSH
  ];
}
