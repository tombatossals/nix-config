{ pkgs, ... }:

{
  home.packages = with pkgs; [
    age # cifrado standalone; es el motor que hay debajo de agenix
    ssh-audit # auditar la configuración de un servidor SSH
  ];
}
