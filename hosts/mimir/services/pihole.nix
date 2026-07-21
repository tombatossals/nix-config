{ config, lib, pkgs, ... }:
{
  # Directorio persistente de configuración de Pi-hole.
  systemd.tmpfiles.rules = [ "d /var/lib/pihole 0755 root root -" ];

  # NOTA: la red dns_net la crea init-dns-net (ver dns-network.nix); no la
  # duplicamos aquí. La ordenación de podman-pihole también está allí.

  virtualisation.oci-containers.containers."pihole" = {
    image = "docker.io/pihole/pihole:latest";
    ports = [ "192.168.4.25:53:53/tcp" "192.168.4.25:53:53/udp" "8888:80/tcp" ];
    environment = {
      TZ = "Europe/Madrid";
      FTLCONF_dns_listeningMode = "all";
      FTLCONF_dns_upstreams = "10.10.10.3#5053";
      FTLCONF_webserver_api_password = "perico123";
      FTLCONF_LOCAL_IPV4 = "10.10.10.2";
    };
    volumes = [ "/var/lib/pihole:/etc/pihole" ];
    extraOptions = [
      "--cap-add=SYS_NICE"
      "--network=dns_net"
      "--ip=10.10.10.2"
      "--label=io.containers.autoupdate=image"
    ];
  };

  # Liberar el puerto 53: Pi-hole hace bind en él, así que el resolver
  # del sistema (systemd-resolved) no debe escuchar ahí.
  services.resolved.enable = false;

  networking.firewall.allowedUDPPorts = [ 53 ];
  networking.firewall.allowedTCPPorts = [ 53 8888 ];
}
