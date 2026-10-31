{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nginx
  ];

  # Enlaza el mime.types del mismo nginx instalado arriba en ~/.config/nginx, para
  # que el nginx.conf gestionado a mano pueda hacer `include mime.types;` sin
  # depender de la ruta del store, que cambia con cada versión.
  xdg.configFile."nginx/mime.types".source = "${pkgs.nginx}/conf/mime.types";
}
