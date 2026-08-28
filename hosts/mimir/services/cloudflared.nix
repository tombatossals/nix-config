{ config, pkgs, host, ... }:
{
  age.identityPaths = [ "/home/nixos/.ssh/agenix" ];
  age.secrets."cloudflared-token".file = ../../../secrets/cloudflared-token-${host}.age;

  # El túnel corre como unidad nativa, no como contenedor: ya usaba red host,
  # así que el contenedor no aportaba aislamiento — solo una imagen `latest`
  # más que vigilar. Aquí la versión la fija nixpkgs y systemd puede acotar
  # los permisos del proceso.
  #
  # No usamos services.cloudflared porque ese módulo exige un credentialsFile
  # (túnel gestionado en local, con el ingress declarado aquí). El nuestro se
  # gestiona desde el panel de Cloudflare y se autentica con TUNNEL_TOKEN, que
  # cloudflared lee del entorno.
  systemd.services.cloudflared = {
    description = "Túnel de Cloudflare";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      # Agenix deja aquí el fichero KEY=VALUE con TUNNEL_TOKEN.
      EnvironmentFile = config.age.secrets."cloudflared-token".path;
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run";
      Restart = "always";
      RestartSec = 5;

      # cloudflared solo abre conexiones salientes: no necesita usuario propio,
      # ni capacidades, ni escribir fuera de su directorio de estado.
      DynamicUser = true;
      StateDirectory = "cloudflared";
      Environment = [ "HOME=%S/cloudflared" ];

      CapabilityBoundingSet = [ "" ];
      NoNewPrivileges = true;
      LockPersonality = true;
      PrivateDevices = true;
      PrivateTmp = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectSystem = "strict";
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" "AF_NETLINK" ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [ "@system-service" ];
    };
  };
}
