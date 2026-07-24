# TODO — Revisión del repo (2026-07-23)

Mejoras detectadas en la revisión de arquitectura y paquetes, pendientes de aplicar. Ordenadas por prioridad.

## 1. Seguridad (lo primero)

- [ ] **Contraseña de Pi-hole en claro** — `hosts/mimir/services/pihole.nix` tiene `FTLCONF_webserver_api_password = "perico123"` en el repo y en la Nix store (legible por cualquier usuario). Pasarla a agenix e inyectarla con `environmentFiles`, igual que hace `cloudflared.nix`.
- [ ] **`secrets/secrets.nix` tiene claves placeholder** (`AAAA_SUSTITUYE...`). Tal como está, `agenix -e` y el re-keying no funcionan. Poner las claves públicas reales (usuario admin + host mimir).
- [ ] **Contraseña de msmtp imperativa** — `passwordeval = "cat /etc/nixos/msmtp-password"` depende de un fichero que nadie gestiona; en una reinstalación el correo deja de funcionar en silencio. Migrar a agenix.
- [ ] **Endurecer acceso** — combinación peligrosa: SSH con `PasswordAuthentication = true` (`modules/services/openssh`), sudo sin contraseña (`modules/system/sudo.nix`) e `initialPassword = "perico"` público en el repo. En mimir (con túnel de Cloudflare) adivinar una contraseña trivial da root. Pasar a SSH solo con clave (`authorizedKeys` declarativas) y `hashedPasswordFile` vía agenix.

## 2. Arquitectura

- [ ] **Eliminar el cherry-picking de mimir** — mover `users.nix`, `autologin.nix` y `boot.nix` de `modules/system/` a `hosts/pulsar/` (son datos de máquina, no módulos genéricos). Así mimir puede importar `modules/system` entero y desaparece la lista frágil de 9 imports en `hosts/mimir/default.nix`.
- [ ] **Helper `mkHome` en `flake.nix`** — las tres `homeConfigurations` repiten la misma estructura y el `rebuildCommand` codifica a mano el nombre que ya está en la clave. Una función de ~10 líneas lo deduplica.
- [ ] **`system.autoUpgrade` no sigue el flake** — está habilitado sin `flake = ...`, así que intenta actualizar vía channels. Apuntarlo al flake.
- [ ] **`delta.nix` huérfano** — no está importado en `cli/default.nix` ni conectado a git. Cablearlo (`programs.git.delta.enable`) o borrarlo.
- [ ] **Duplicados en `cli/packages.nix`** — bat, eza, fzf, tmux, yazi y zoxide ya se instalan vía `programs.*.enable`; quitarlos de `home.packages`.
- [ ] **Perfil `gui` inconsistente** (está comentado, pero antes de reactivarlo): dos lanzadores (fuzzel y walker), dos demonios de notificaciones (mako y swaync), `hyprland.nix` vacío, y el `loginExtra` de zsh ejecuta `start-hyprland`, que ningún paquete define. Decidir y limpiar.
- [ ] **Identidad de git compartida** — `git.nix` fija `david.rubert@gmail.com` en todos los hosts; en haddock (usuario vrubert) debería ser probablemente vrubert@uji.es. Parametrizar por host vía `extraSpecialArgs` (como `rebuildCommand`).
- [ ] **Limpieza de `environment.nix`** — `home.sessionVariables.PATH` y `home.sessionPath` duplican lo mismo (quedarse con `sessionPath`); `LD_LIBRARY_PATH` global es fuente clásica de binarios rotos en Linux, mejor moverlo a direnv por proyecto.
- [ ] **DNS del propio mimir** — el host se pone a sí mismo (192.168.4.25) como primer nameserver; si el contenedor de Pi-hole está caído, el host se queda sin DNS justo cuando hace falta hacer `rebuild`. Dejar un upstream directo como primario para el host.
- [ ] **`README.md` vacío** — rellenarlo o borrarlo.

## 3. Paquetes y herramientas que faltan

Casi imprescindibles:

- [ ] `dnsutils` o `doggo` + `mtr` — se administra un servidor DNS y no hay `dig` en ningún perfil.
- [ ] `nvd` — ver qué cambia entre generaciones al hacer `rebuild` (integrable en el alias).
- [ ] `statix` + `deadnix` — linters de Nix; añadir también `formatter = pkgs.alejandra` al flake para que `nix fmt` funcione fuera de lazyvim.
- [ ] CLIs de `home-manager` y `agenix` instalados desde los inputs del flake — ahora `rebuild` en los Mac descarga home-manager de GitHub cada vez, y editar secretos requiere `nix run github:ryantm/agenix`.
- [ ] `restic` o `borgbackup` — hay `rclone` pero nada de backups versionados (p. ej. `/var/lib/pihole` en mimir).

Muy recomendables:

- [ ] `gh` — CLI de GitHub.
- [ ] `atuin` — historial de shell sincronizado entre máquinas.
- [ ] `watchexec` o `entr` — generaliza lo que `cargo-watch` hace solo para Rust.
- [ ] `shellcheck` + `shfmt` — no hay nada para scripts de shell en el perfil dev.
- [ ] `xh` o `httpie` — cliente HTTP moderno.
- [ ] `nix-tree` y `comma` — inspeccionar closures y ejecutar programas no instalados.

Opcionales según uso: `sd`, `yq`, `tokei`, `git-absorb`; en los Mac, `podman` + `colima` para reproducir en local los contenedores de mimir.
