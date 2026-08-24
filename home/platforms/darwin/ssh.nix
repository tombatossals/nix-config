{ ... }:

# Añadido específico de macOS sobre la configuración de ops/ssh.nix.
# UseKeychain solo lo entiende el ssh de Apple (que es el que se usa: el
# módulo de home-manager no instala openssh salvo que se le pida).
{
  programs.ssh.settings."*" = {
    UseKeychain = "yes";
  };
}
