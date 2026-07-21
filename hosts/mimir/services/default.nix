{ ... }:

{
  imports = [
    ./dns-network.nix
    ./cloudflared.nix
    ./dnscrypt-proxy.nix
    ./pihole.nix
    ./msmtp.nix
  ];

  # Los servicios de mimir se ejecutan como contenedores gestionados por Podman.
  virtualisation.oci-containers.backend = "podman";
}
