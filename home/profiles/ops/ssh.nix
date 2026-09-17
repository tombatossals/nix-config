{ pkgs, ... }:

# Configuración declarativa del cliente SSH. Este repositorio ya conoce las
# máquinas, así que el ~/.ssh/config sale de aquí en vez de escribirse a mano
# en cada host.
#
# Nota: se usa `programs.ssh.settings` (nombres de directiva de OpenSSH tal
# cual); `matchBlocks` está deprecado en home-manager 26.05.
{
  home.packages = with pkgs; [
    mosh # sesiones que sobreviven a cambios de red y latencia alta
    cloudflared # ProxyCommand del bloque hades.micronautas.com
  ];

  programs.ssh = {
    enable = true;

    # Los valores por defecto heredados del módulo están deprecados; se
    # declaran abajo de forma explícita en el bloque "*".
    enableDefaultConfig = false;

    settings = {
      "*" = {
        AddKeysToAgent = "yes";
        Compression = false;
        ForwardAgent = false;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";

        # Multiplexado: la segunda conexión al mismo host reutiliza la primera.
        # El ControlPath no necesita crear directorios.
        ControlMaster = "auto";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "10m";

        # Mantener viva la sesión a través de NAT y wifi malo.
        ServerAliveInterval = 30;
        ServerAliveCountMax = 6;
      };

      # ── Máquinas propias ────────────────────────────────────────────────
      # mimir tiene IP fija (ver hosts/mimir/networking.nix).
      mimir = {
        HostName = "192.168.4.25";
        User = "nixos";
      };

      # El resto se resuelven por mDNS. Si tu red no lo hace, sustituye
      # HostName por la IP correspondiente.
      pulsar = {
        HostName = "pulsar.local";
        User = "dave";
      };

      hades = {
        HostName = "hades.local";
        User = "dave";
      };

      # Acceso a hades desde fuera de casa: no hay puerto abierto, la sesión
      # entra por el túnel de Cloudflare Access. Requiere `cloudflared` en el
      # PATH (declarado arriba en home.packages) y haberse autenticado antes
      # con `cloudflared access login hades.micronautas.com`.
      "hades.micronautas.com" = {
        HostName = "hades.micronautas.com";
        User = "dave";
        IdentityFile = "~/.ssh/id_ed25519";
        ProxyCommand = "cloudflared access ssh --hostname %h";
      };

      # calipso es Windows 11 Pro: el sshd que interesa es el de dentro de
      # WSL2, no el de Windows. Ajusta el puerto si lo reenvías.
      calipso = {
        HostName = "calipso.local";
        User = "dave";
      };

      # ── Routers MikroTik ────────────────────────────────────────────────
      # El .8 (2011-uji) tiene autorizada la ed25519 id_mikrotik
      # (huella SHA256:mY8Dst...). Se restringe a esa clave para no ofrecer
      # antes id_ed25519 (que ese RouterOS no tiene registrada).
      "192.168.4.8" = {
        User = "admin";
        IdentityFile = "~/.ssh/id_mikrotik";
        IdentitiesOnly = "yes";
      };

      "github.com" = {
        User = "git";
      };
    };
  };
}
