{ pkgs, ... }:

# Paquetes unfree; hay que declararlos en el allowUnfreePredicate de
# flake.nix para los hosts que importen esta plataforma.
{
  home.packages = with pkgs; [
    oracle-instantclient
    sqlcl # antes instalado a mano en /opt/sqlcl/bin
  ];
}
