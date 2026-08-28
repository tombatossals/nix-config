{ pkgs, ... }:

# Ghostty (el terminal de ares/haddock) exporta TERM=xterm-ghostty y ssh se lo
# pasa al host remoto; sin esta entrada de terminfo, entrar por ssh falla con
# "can't find terminal definition for xterm-ghostty".
#
# En los hosts NixOS esto lo resuelve modules/system/terminfo.nix a nivel de
# sistema. Aquí, en cambio, home-manager es standalone sobre una distro que no
# controlamos (calipso es Ubuntu dentro de WSL2), así que instalar el paquete no
# bastaría: la ncurses del sistema no mira el perfil de Nix salvo que
# TERMINFO_DIRS lo incluya. ~/.terminfo sí lo consulta siempre, sin depender de
# variables de entorno ni de qué shell arranque la sesión.
{
  home.file = {
    ".terminfo/x/xterm-ghostty".source = "${pkgs.ghostty.terminfo}/share/terminfo/x/xterm-ghostty";
    ".terminfo/g/ghostty".source = "${pkgs.ghostty.terminfo}/share/terminfo/x/xterm-ghostty";
  };
}
