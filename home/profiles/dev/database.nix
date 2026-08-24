{ pkgs, ... }:

{
  home.packages = with pkgs; [
    sqlite
    postgresql

    # REPLs con autocompletado y resaltado, uno por motor.
    litecli # sqlite
    mycli # mysql/mariadb
    pgcli # postgresql

    usql # cliente universal; una sola sintaxis de conexión para todos
  ];
}
