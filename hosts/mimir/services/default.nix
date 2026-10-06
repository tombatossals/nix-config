{ ... }:

{
  imports = [
    ./cloudflared.nix
    ./dnscrypt-proxy.nix
    ./pihole.nix
    ./msmtp.nix
    ./mikrotik-backup.nix
  ];

  # Pi-hole es el único servicio que corre como contenedor; dnscrypt-proxy,
  # cloudflared, msmtp y la copia de los MikroTik son servicios nativos de NixOS.
  virtualisation.oci-containers.backend = "podman";
}
