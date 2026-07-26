{ config, pkgs, ... }:

{
  users.users.dave = {
    isNormalUser = true;
    description = "David Rubert";

    shell = pkgs.zsh;

    extraGroups = [
      "wheel"
      "networkmanager"
    ];

    # Clave SSH autorizada (login solo con clave; ver modules/services/openssh).
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK2c7PDtuKcnbpnJeUI4CPNncKfK/h3+5q0R/acTV/2q david.rubert@gmail.com"
    ];

    # Hash yescrypt de una contraseña fuerte (sustituye a initialPassword="perico").
    # pulsar no tiene agenix configurado, así que el hash se comitea directamente:
    # un hash no es secreto-crítico (es lo que guarda /etc/shadow) y la contraseña
    # es aleatoria. Migrar a hashedPasswordFile cuando pulsar tenga agenix.
    hashedPassword = "$y$j9T$RkSNEw1N61s9nnPV1OjkX/$rjlY8GfEIowLnzzI017rRsfh9QCtCckCLE8FlDScSAA";
  };
}
