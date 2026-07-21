{ pkgs, ... }:

{
  # Red interna de podman para el stack DNS (dnscrypt-proxy usa 10.10.10.3).
  # oci-containers no crea redes, así que la creamos con un oneshot idempotente.
  systemd.services.init-dns-net = {
    description = "Crea la red podman dns_net";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      ${pkgs.podman}/bin/podman network exists dns_net \
        || ${pkgs.podman}/bin/podman network create --subnet 10.10.10.0/24 dns_net
    '';
  };

  # Los contenedores conectados a dns_net deben esperar a que la red exista.
  systemd.services."podman-dnscrypt-proxy" = {
    after = [ "init-dns-net.service" ];
    requires = [ "init-dns-net.service" ];
  };

  systemd.services."podman-pihole" = {
    after = [ "init-dns-net.service" ];
    requires = [ "init-dns-net.service" ];
  };
}
