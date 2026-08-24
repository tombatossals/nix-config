{ pkgs, ... }:

# macOS trae las utilidades BSD, cuyo comportamiento difiere del de GNU en
# cosas cotidianas (`sed -i`, `date -d`, `grep -P`). Instalando las GNU aquí,
# los scripts se comportan igual en ares/haddock que en pulsar/hades/calipso.
#
# Ojo: nixpkgs las instala sin prefijo `g`, así que estas versiones ganan a las
# de /usr/bin en el PATH. Es justo lo que se busca.
{
  home.packages = with pkgs; [
    coreutils
    findutils
    gawk
    gnugrep
    gnused

    watch # en macOS no existe; en Linux viene con procps
  ];
}
