{ lib, pkgs, ... }:
let
  mikrotiks = import ./mikrotik-hosts.nix;

  # Repositorio privado de GitHub al que se empuja cada copia.
  remoto = "git@github.com:tombatossals/mikrotik-backup.git";

  # Clave de servidor publicada por GitHub: fijada aquí para no fiarse de la
  # primera conexión.
  githubKnownHosts = pkgs.writeText "github-known-hosts" ''
    github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
  '';

  # Cada noche se conecta por SSH a cada MikroTik como el usuario de solo
  # lectura `backup`, guarda su `/export` en un repositorio git local, hace
  # commit si algo ha cambiado y lo empuja a GitHub. El historial de git es la
  # retención.
  #
  # Las dos claves se generan aquí la primera vez y nunca salen de mimir:
  # - id_ed25519: su parte pública va en cada router (usuario backup, grupo
  #   con políticas ssh,read).
  # - id_github: deploy key con escritura, solo en el repositorio de GitHub.
  # El export no incluye contraseñas ni claves privadas.
  copia = pkgs.writeShellApplication {
    name = "mikrotik-backup";
    runtimeInputs = with pkgs; [ openssh git coreutils gnused gnugrep ];
    text = ''
      cd "$STATE_DIRECTORY"

      if [ ! -f id_ed25519 ]; then
        ssh-keygen -q -t ed25519 -N "" -C "mikrotik-backup@mimir" -f id_ed25519
      fi
      if [ ! -f id_github ]; then
        ssh-keygen -q -t ed25519 -N "" -C "mikrotik-backup@mimir (deploy key)" -f id_github
      fi
      [ -d repo/.git ] || git init -q -b main repo
      git -C repo remote get-url origin >/dev/null 2>&1 \
        || git -C repo remote add origin ${lib.escapeShellArg remoto}

      fallos=()
      for par in ${lib.escapeShellArgs (lib.mapAttrsToList (nombre: ip: "${nombre}=${ip}") mikrotiks)}; do
        nombre=''${par%%=*}
        ip=''${par#*=}
        if ssh -n -i id_ed25519 -o IdentitiesOnly=yes -o BatchMode=yes \
             -o ConnectTimeout=20 -o StrictHostKeyChecking=accept-new \
             -o UserKnownHostsFile="$STATE_DIRECTORY/known_hosts" \
             "backup@$ip" "/export terse" > "repo/$nombre.tmp" \
           && grep -q "^# software id" "repo/$nombre.tmp"; then
          # La primera línea lleva la fecha del export: fuera, para que git
          # solo registre cambios reales de configuración.
          sed '1{/ by RouterOS /d}' "repo/$nombre.tmp" > "repo/$nombre.rsc"
        else
          fallos+=("$nombre ($ip)")
        fi
        rm -f "repo/$nombre.tmp"
      done

      git -C repo add -A
      git -C repo -c user.name=mikrotik-backup -c user.email=mikrotik-backup@mimir \
        commit -q -m "Copia $(date +%F)" || true

      # Empuja todo lo pendiente: si un día falla la red, al siguiente sube
      # también los commits atrasados.
      if ! GIT_SSH_COMMAND="ssh -i $STATE_DIRECTORY/id_github -o IdentitiesOnly=yes -o BatchMode=yes -o UserKnownHostsFile=${githubKnownHosts} -o StrictHostKeyChecking=yes" \
           git -C repo push -q origin main; then
        fallos+=("push a GitHub")
      fi

      if [ ''${#fallos[@]} -gt 0 ]; then
        echo "Sin copia de: ''${fallos[*]}" >&2
        exit 1
      fi
    '';
  };
in
{
  systemd.services.mikrotik-backup = {
    description = "Copia de la configuración de los MikroTik";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    # Si falla algún router llega un correo (msmtp, alias root).
    onFailure = [ "mikrotik-backup-aviso.service" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = lib.getExe copia;

      # Mismo planteamiento que cloudflared.nix: usuario efímero y solo su
      # directorio de estado (/var/lib/private/mikrotik-backup) con escritura.
      DynamicUser = true;
      StateDirectory = "mikrotik-backup";
      Environment = [ "HOME=%S/mikrotik-backup" ];

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
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [ "@system-service" ];
    };
  };

  systemd.services.mikrotik-backup-aviso = {
    description = "Aviso por correo de copia de MikroTik fallida";
    serviceConfig.Type = "oneshot";
    script = ''
      printf 'To: root\nSubject: [mimir] Falla la copia de los MikroTik\n\n%s\n' \
        "$(journalctl -u mikrotik-backup -n 20 --no-pager)" \
        | /run/wrappers/bin/sendmail -t
    '';
  };

  systemd.timers.mikrotik-backup = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      # Antes de la actualización automática de las 04:00.
      OnCalendar = "*-*-* 03:30";
      Persistent = true;
    };
  };
}
