# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Qué es esto

Un flake de Nix (nixpkgs `nixos-26.05`, home-manager `release-26.05`) que gestiona cinco máquinas:

- **pulsar** — sistema NixOS completo (aarch64-linux) con home-manager integrado como módulo de NixOS (usuario `dave`). Usa disko para el particionado de disco.
- **mimir** — sistema NixOS completo (aarch64-linux), un appliance de red/DNS sin interfaz gráfica (usuario `nixos`). Sus servicios (Pi-hole, túnel de cloudflared, dnscrypt-proxy, msmtp) corren como contenedores OCI de Podman definidos en `hosts/mimir/services/`. Usa disko y agenix.
- **dave@ares** — solo home-manager standalone (aarch64-darwin, macOS). Permite el paquete unfree `oracle-instantclient`.
- **dave@hades** — solo home-manager standalone (x86_64-linux).
- **vrubert@haddock** — solo home-manager standalone (aarch64-darwin, macOS); mismo conjunto de perfiles que dave@ares pero para el usuario `vrubert`.

## Comandos

```sh
# Validar el flake (también disponible como alias `nc` en la configuración del shell)
nix flake check ~/nix-config

# Aplicar — hosts NixOS
sudo nixos-rebuild switch --flake ~/nix-config#pulsar
sudo nixos-rebuild switch --flake ~/nix-config#mimir

# Aplicar — hosts de home-manager standalone
nix run github:nix-community/home-manager/release-26.05 -- switch --flake ~/nix-config#dave@ares
nix run github:nix-community/home-manager/release-26.05 -- switch --flake ~/nix-config#dave@hades
nix run github:nix-community/home-manager/release-26.05 -- switch --flake ~/nix-config#vrubert@haddock

# Editar un secreto de agenix (ejecutar desde secrets/; las claves se declaran en secrets/secrets.nix)
nix run github:ryantm/agenix -- -e <nombre>.age
```

No hay tests ni linters más allá de `nix flake check`.

## Arquitectura

Tres capas, conectadas entre sí por `flake.nix`:

- **`hosts/`** — un directorio por máquina; el único sitio donde viven los datos específicos de cada máquina (nombre de usuario, ruta del directorio home, configuración de hardware, layout de disko, red, servicios locales del host). `hosts/<nombre>/home.nix` (o las `homeConfigurations` del flake) importa un punto de entrada `home/<usuario>` más el `home/platforms/{darwin,linux}` correspondiente.
- **`modules/`** — módulos de sistema solo para NixOS (`system/`, `services/`, `desktop/`). pulsar importa el árbol completo vía `modules/default.nix`; mimir en cambio selecciona ficheros individuales de `modules/system/` y `modules/services/`, porque el agregado arrastra el usuario `dave`, el autologin y la configuración de arranque EFI de pulsar.
- **`home/`** — configuración de home-manager, compartida entre todas las máquinas:
  - `home/dave/default.nix` — punto de entrada de usuario para los hosts basados en dave; selecciona qué perfiles están activos (`gui` está actualmente comentado).
  - `home/nixos/default.nix` — punto de entrada de usuario para el usuario `nixos` de mimir (solo perfil cli + plataforma linux).
  - `home/profiles/{cli,dev,gui}` — paquetes de funcionalidad, un fichero por programa; el `default.nix` de cada directorio es solo una lista de imports.
  - `home/platforms/{darwin,linux}` — añadidos específicos de cada SO que el host superpone encima.

**`secrets/`** — secretos cifrados con agenix. `secrets/secrets.nix` declara qué claves públicas SSH (usuario administrador + host consumidor) pueden descifrar cada fichero `.age`. Los hosts NixOS que consumen secretos importan `inputs.agenix.nixosModules.default` (ver `hosts/mimir/default.nix`).

Todos los `default.nix` de este repositorio son agregadores de imports; la configuración real vive en los ficheros `.nix` por programa. Para añadir un programa, crea un fichero en el perfil adecuado y añádelo al `default.nix` de ese perfil.

Los comentarios de este repositorio están escritos en castellano; mantén esa convención al editar.

### La convención `rebuildCommand`

Cada host pasa su propio comando de rebuild a home-manager — los hosts standalone vía `extraSpecialArgs` en `flake.nix`, los hosts NixOS vía `extraSpecialArgs` en `hosts/<nombre>/home.nix` — y `home/profiles/cli/aliases.nix` lo vincula al alias de shell `rebuild`. Un host nuevo debe proporcionar `rebuildCommand` o la evaluación de home-manager falla.

## Añadir un host nuevo

1. Crea `hosts/<nombre>/` con un `home.nix` (y configuración de sistema si es NixOS).
2. Regístralo en `flake.nix` bajo `nixosConfigurations` o `homeConfigurations`, pasando `inputs`, `self` y `rebuildCommand`.
3. Importa un punto de entrada `home/<usuario>` más el directorio `home/platforms/` apropiado, y define `home.homeDirectory`.
