{ pkgs, ... }:

# Mapa de la red de casa (github.com/tombatossals/red-casa): recoge cada 10 min
# las tablas de los MikroTik, publica ~/network/web y avisa por correo de
# los equipos nuevos. El código y el inventario viven en el repositorio
# (clonado en ~/red-casa); aquí solo se declaran los temporizadores y el entorno.
#
# ~/network/web es un enlace simbólico a la versión vigente (~/network/web.versiones/…).
# Queda fuera de /srv/http a propósito: /srv/http es la raíz del sitio público de
# nginx y la página solo debe verse a través de Cloudflare Access.
let
  python = pkgs.python3.withPackages (p: [ p.pyyaml ]);
  comun = "--repo %h/red-casa --estado-dir %h/.local/state/red-casa --destino %h/network/web --clave %h/.ssh/id_red_casa";
  entorno = [ "PATH=${pkgs.openssh}/bin:${pkgs.git}/bin:/usr/bin" ];
in
{
  systemd.user.services.red-casa = {
    Unit.Description = "Mapa de la red de casa: recoger y publicar";
    Service = {
      Type = "oneshot";
      WorkingDirectory = "%h/red-casa";
      Environment = entorno;
      # Un fallo de red al actualizar el repositorio no impide publicar.
      ExecStartPre = "-${pkgs.git}/bin/git -C %h/red-casa pull --ff-only -q";
      ExecStart = "${python}/bin/python -m recolector recoger ${comun}";
      TimeoutStartSec = "8min";
    };
  };
  systemd.user.timers.red-casa = {
    Unit.Description = "Mapa de la red de casa cada 10 minutos";
    Timer = { OnCalendar = "*:0/10"; Persistent = true; };
    Install.WantedBy = [ "timers.target" ];
  };

  systemd.user.services.red-casa-resumen = {
    Unit.Description = "Mapa de la red de casa: resumen diario por correo";
    Service = {
      Type = "oneshot";
      WorkingDirectory = "%h/red-casa";
      Environment = entorno;
      ExecStart = "${python}/bin/python -m recolector resumen ${comun}";
    };
  };
  systemd.user.timers.red-casa-resumen = {
    Unit.Description = "Resumen diario del mapa de la red";
    Timer = { OnCalendar = "*-*-* 08:00"; Persistent = true; };
    Install.WantedBy = [ "timers.target" ];
  };
}
