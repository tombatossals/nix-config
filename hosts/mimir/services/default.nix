{ ... }:

{
  imports = [
    ./cloudflared.nix
    ./dnscrypt-proxy.nix
    ./pihole.nix
    ./msmtp.nix
  ];

  # Pi-hole, cloudflared y msmtp corren como contenedores; dnscrypt-proxy es
  # un servicio nativo de NixOS (ver dnscrypt-proxy.nix).
  virtualisation.oci-containers.backend = "podman";
}
