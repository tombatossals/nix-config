{ config, host, ... }:
{
  # Directorio persistente de configuración de Pi-hole.
  systemd.tmpfiles.rules = [ "d /var/lib/pihole 0755 root root -" ];

  # La contraseña del panel se inyecta vía agenix (fichero KEY=VALUE), igual
  # que el token de cloudflared. No vive en claro ni en el repo ni en la store.
  age.secrets."pihole-password".file = ../../../secrets/pihole-password-${host}.age;

  virtualisation.oci-containers.containers."pihole" = {
    image = "docker.io/pihole/pihole:latest";

    # Red host: Pi-hole hace bind directamente en las interfaces de mimir, sin
    # bridge de podman de por medio. Así puede hablar con dnscrypt-proxy por
    # 127.0.0.1 y no hace falta ni red propia ni mapeo de puertos.
    environment = {
      TZ = "Europe/Madrid";
      FTLCONF_dns_listeningMode = "all";
      FTLCONF_dns_upstreams = "127.0.0.1#5053";
      FTLCONF_webserver_port = "8888";
      FTLCONF_LOCAL_IPV4 = "192.168.4.25";
    };
    # FTLCONF_webserver_api_password llega desde el secreto agenix.
    environmentFiles = [ config.age.secrets."pihole-password".path ];
    volumes = [ "/var/lib/pihole:/etc/pihole" ];
    extraOptions = [
      "--cap-add=SYS_NICE"
      "--network=host"
      "--label=io.containers.autoupdate=image"
    ];
  };

  # Pi-hole no sirve de nada hasta que su upstream esté escuchando.
  systemd.services."podman-pihole" = {
    after = [ "dnscrypt-proxy.service" ];
    wants = [ "dnscrypt-proxy.service" ];
  };

  # Liberar el puerto 53: Pi-hole hace bind en él, así que el resolver
  # del sistema (systemd-resolved) no debe escuchar ahí.
  services.resolved.enable = false;

  networking.firewall.allowedUDPPorts = [ 53 ];
  networking.firewall.allowedTCPPorts = [ 53 8888 ];
}
