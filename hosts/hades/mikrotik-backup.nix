{ lib, pkgs, ... }:

# Copia nocturna de la configuración de los MikroTik (antes en mimir): entra
# por SSH en cada router, guarda su `/export` en un repositorio git, hace
# commit si algo ha cambiado y lo empuja a GitHub. El historial de git es la
# retención. El export no incluye contraseñas ni claves privadas.
#
# Entra como `inventario`, el mismo usuario de solo lectura (ssh,read, limitado
# a 192.168.4.10) que usa el mapa de la red (red-casa.nix), con su clave y su
# known_hosts: así una clave de host nueva tras actualizar RouterOS se limpia
# en un solo sitio.
let
  mikrotiks = import ../mimir/services/mikrotik-hosts.nix;

  # Equipos que no entran en la copia automática. placas (RB750, CPU al 100 %)
  # agota el tiempo de RouterOS en varias secciones y su export sale
  # incompleto casi siempre; se quita cuando se sustituya el equipo.
  excluidos = [ "placas" ];
  respaldados = lib.filterAttrs (nombre: _: !(lib.elem nombre excluidos)) mikrotiks;

  # Equipos que de noche suelen estar apagados: 2011-uji se queda sin PoE por
  # el scheduler apaga-2011-uji de crs328. Si no responden se conserva su
  # última copia y no cuenta como fallo.
  puedenEstarApagados = [ "2011-uji" ];

  # Repositorio privado de GitHub al que se empuja cada copia.
  remoto = "git@github.com:tombatossals/mikrotik-backup.git";

  # Clave de servidor publicada por GitHub: fijada aquí para no fiarse de la
  # primera conexión.
  githubKnownHosts = pkgs.writeText "github-known-hosts" ''
    github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
  '';

  # id_github (deploy key con escritura, solo en el repositorio de GitHub) se
  # genera aquí la primera vez y nunca sale de hades.
  #
  # Los dos ssh (routers y GitHub) llevan ForwardX11=no: el ~/.ssh/config de
  # hades lo activa y, sin pantalla, cada conexión deja un aviso de xauth.
  copia = pkgs.writeShellApplication {
    name = "mikrotik-backup";
    runtimeInputs = with pkgs; [ openssh git coreutils gnused gnugrep ];
    text = ''
      cd "$STATE_DIRECTORY"
      clave="$HOME/.ssh/id_red_casa"
      known_hosts="$HOME/.local/state/red-casa/known_hosts"

      if [ ! -f id_github ]; then
        ssh-keygen -q -t ed25519 -N "" -C "mikrotik-backup@hades (deploy key)" -f id_github
      fi
      export GIT_SSH_COMMAND="ssh -i $STATE_DIRECTORY/id_github -o IdentitiesOnly=yes -o BatchMode=yes -o ControlMaster=no -o ControlPath=none -o ForwardX11=no -o UserKnownHostsFile=${githubKnownHosts} -o StrictHostKeyChecking=yes"
      # Se parte del historial que ya hay en GitHub para seguir empujando encima.
      [ -d repo/.git ] || git clone -q ${lib.escapeShellArg remoto} repo

      apagables=(${lib.escapeShellArgs puedenEstarApagados})
      fallos=()
      for par in ${lib.escapeShellArgs (lib.mapAttrsToList (nombre: ip: "${nombre}=${ip}") respaldados)}; do
        nombre=''${par%%=*}
        ip=''${par#*=}
        if [[ " ''${apagables[*]} " == *" $nombre "* ]] \
           && ! timeout 5 bash -c "</dev/tcp/$ip/22" 2>/dev/null; then
          echo "$nombre ($ip) apagado: se conserva su última copia"
          continue
        fi
        # Tope de 10 minutos por equipo: un router colgado no debe bloquear al resto.
        if timeout 600 ssh -n -i "$clave" -o IdentitiesOnly=yes -o BatchMode=yes \
             -o ControlMaster=no -o ControlPath=none -o ForwardX11=no \
             -o ConnectTimeout=20 -o StrictHostKeyChecking=accept-new \
             -o UserKnownHostsFile="$known_hosts" \
             "inventario@$ip" "/export terse" > "repo/$nombre.tmp" \
           && grep -q "^# software id" "repo/$nombre.tmp"; then
          if grep -q "^#error exporting" "repo/$nombre.tmp"; then
            # RouterOS se ha saltado secciones por tiempo agotado: no se pisa
            # la última copia buena con una parcial.
            fallos+=("$nombre ($ip): export incompleto")
          else
            # Fuera lo que cambia sin que cambie la configuración, para que git
            # solo registre cambios reales: la fecha del export (primera línea)
            # y el estado de las radios wifi ("# mode: AP, SSID: …, channel: …",
            # que varía con la ocupación o con un cambio de canal por DFS).
            sed -e '1{/ by RouterOS /d}' -e '/^# mode: /d' "repo/$nombre.tmp" > "repo/$nombre.rsc"
          fi
        else
          fallos+=("$nombre ($ip)")
        fi
        rm -f "repo/$nombre.tmp"
      done

      # Un equipo excluido no deja en el repositorio una copia vieja o
      # incompleta que parezca válida.
      excluidos=(${lib.escapeShellArgs excluidos})
      for nombre in "''${excluidos[@]}"; do
        rm -f "repo/$nombre.rsc"
      done

      git -C repo add -A
      git -C repo -c user.name=mikrotik-backup -c user.email=mikrotik-backup@hades \
        commit -q -m "Copia $(date +%F)" || true

      # Empuja todo lo pendiente: si un día falla la red, al siguiente sube
      # también los commits atrasados.
      if ! git -C repo push -q origin main; then
        fallos+=("push a GitHub")
      fi

      if [ ''${#fallos[@]} -gt 0 ]; then
        echo "Sin copia de: ''${fallos[*]}" >&2
        exit 1
      fi
    '';
  };

  # hades no tiene sendmail: el aviso sale por el SMTP local, como los del mapa
  # de la red (recolector/avisos.py).
  aviso = pkgs.writeShellApplication {
    name = "mikrotik-backup-aviso";
    runtimeInputs = with pkgs; [ python3 systemd ];
    text = ''
      journalctl --user -u mikrotik-backup -n 20 --no-pager | python3 -c '
      import smtplib, sys
      from email.message import EmailMessage
      m = EmailMessage()
      m["From"] = m["To"] = "david.rubert@gmail.com"
      m["Subject"] = "[hades] Falla la copia de los MikroTik"
      m.set_content(sys.stdin.read())
      with smtplib.SMTP("localhost", 25, timeout=30) as s:
          s.send_message(m)
      '
    '';
  };
in
{
  systemd.user.services.mikrotik-backup = {
    Unit = {
      Description = "Copia de la configuración de los MikroTik";
      # Si falla algún router llega un correo.
      OnFailure = [ "mikrotik-backup-aviso.service" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = lib.getExe copia;
      # ~/.local/state/mikrotik-backup: deploy key y repositorio.
      StateDirectory = "mikrotik-backup";
    };
  };

  systemd.user.services.mikrotik-backup-aviso = {
    Unit.Description = "Aviso por correo de copia de MikroTik fallida";
    Service = {
      Type = "oneshot";
      ExecStart = lib.getExe aviso;
    };
  };

  systemd.user.timers.mikrotik-backup = {
    Unit.Description = "Copia diaria de la configuración de los MikroTik";
    Timer = {
      OnCalendar = "*-*-* 03:30";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
