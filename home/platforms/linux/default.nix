{ pkgs, ... }:

{
  imports = [
  ];

  home.packages = with pkgs; [
    pciutils # lspci
    sshfs # montar directorios remotos por SSH
  ];
}
