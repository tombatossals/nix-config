{ ... }:

{
  imports = [
    ./cloudflared.nix
    ./dnscrypt-proxy.nix
    ./pihole.nix
    ./msmtp.nix
  ];

  # Pi-hole es el único servicio que corre como contenedor; dnscrypt-proxy,
  # cloudflared y msmtp son servicios nativos de NixOS.
  virtualisation.oci-containers.backend = "podman";
}
