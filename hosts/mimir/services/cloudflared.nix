{ config, host, ... }:
{
  age.identityPaths = [ "/home/nixos/.ssh/agenix" ];
  age.secrets."cloudflared-token".file = ../../../secrets/cloudflared-token-${host}.age;

  virtualisation.oci-containers.containers."cloudflared" = {
    image = "docker.io/cloudflare/cloudflared:latest";

    # Agenix inyecta el archivo aquí, y Podman lo lee como variables de entorno
    environmentFiles = [
      config.age.secrets."cloudflared-token".path
    ];

    # Comando limpio (cloudflared leerá TUNNEL_TOKEN del entorno automáticamente)
    cmd = [ "tunnel" "--no-autoupdate" "run" ];

    extraOptions = [
      "--network=host"
      "--label=io.containers.autoupdate=image"
    ];
  };
}
