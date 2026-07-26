{ config, pkgs, host, ... }:

{
  # Hash de la contraseña de login, descifrado por agenix al arrancar
  # (mimir usa la clave de /home/nixos/.ssh/agenix; ver cloudflared.nix).
  age.secrets."login-password".file = ../../secrets/login-password-${host}.age;

  users.users.nixos = {
    isNormalUser = true;
    description = "NixOS";

    shell = pkgs.zsh;

    extraGroups = [
      "wheel"
    ];

    # Clave SSH autorizada (login solo con clave; ver modules/services/openssh).
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK2c7PDtuKcnbpnJeUI4CPNncKfK/h3+5q0R/acTV/2q david.rubert@gmail.com"
    ];

    # Sustituye a initialPassword="perico". El hash vive cifrado en agenix.
    hashedPasswordFile = config.age.secrets."login-password".path;
  };
}
