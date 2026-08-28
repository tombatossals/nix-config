{ pkgs, ... }:

{
  # Ghostty (el terminal de ares/haddock) exporta TERM=xterm-ghostty, y ssh se
  # lo pasa al host remoto. Sin esta entrada de terminfo, cualquier programa con
  # ncurses falla al entrar con "can't find terminal definition for
  # xterm-ghostty". Es un output aparte del paquete: pesa unos 5 KiB y no
  # arrastra el terminal entero.
  environment.systemPackages = [ pkgs.ghostty.terminfo ];
}
