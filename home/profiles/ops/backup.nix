{ pkgs, ... }:

# rclone (en el perfil cli) sincroniza; restic hace snapshots deduplicados
# y cifrados con política de retención. Son cosas distintas y se complementan.
{
  home.packages = with pkgs; [
    restic
  ];
}
