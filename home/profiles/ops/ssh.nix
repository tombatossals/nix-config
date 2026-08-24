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

      # calipso es Windows 11 Pro: el sshd que interesa es el de dentro de
      # WSL2, no el de Windows. Ajusta el puerto si lo reenvías.
      calipso = {
        HostName = "calipso.local";
        User = "dave";
      };

      "github.com" = {
        User = "git";
      };
    };
  };
}
