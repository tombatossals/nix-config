# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Nix flake (nixpkgs/home-manager `release-26.05`) managing three machines:

- **pulsar** — full NixOS system (aarch64-linux) with home-manager integrated as a NixOS module. Uses disko for disk layout.
- **dave@ares** — standalone home-manager only (aarch64-darwin, macOS). Allows the unfree `oracle-instantclient` package.
- **dave@hades** — standalone home-manager only (x86_64-linux).
- **vrubert@haddock** — standalone home-manager only (aarch64-darwin, macOS); same profile set as dave@ares but for user `vrubert`.

## Commands

```sh
# Validate the flake (also aliased as `nc` in the shell config)
nix flake check ~/nix-config

# Apply — NixOS host (pulsar)
sudo nixos-rebuild switch --flake ~/nix-config#pulsar

# Apply — standalone home-manager hosts
nix run github:nix-community/home-manager/release-26.05 -- switch --flake ~/nix-config#dave@ares
nix run github:nix-community/home-manager/release-26.05 -- switch --flake ~/nix-config#dave@hades
nix run github:nix-community/home-manager/release-26.05 -- switch --flake ~/nix-config#vrubert@haddock
```

There are no tests or linters beyond `nix flake check`.

## Architecture

Three layers, wired together by `flake.nix`:

- **`hosts/`** — one directory per machine; the only place machine-specific facts live (username, home directory path, hardware config, disko layout, networking). `hosts/<name>/home.nix` (or the flake's `homeConfigurations`) imports `home/dave` plus the matching `home/platforms/{darwin,linux}`.
- **`modules/`** — NixOS-only system modules (`system/`, `services/`, `desktop/`), imported as a whole by pulsar via `modules/default.nix`. Not used by the standalone home-manager hosts.
- **`home/`** — home-manager config, shared across all machines:
  - `home/dave/default.nix` — the user entry point; selects which profiles are active (`gui` is currently commented out).
  - `home/profiles/{cli,dev,gui}` — feature bundles, one file per program; each directory's `default.nix` is just an import list.
  - `home/platforms/{darwin,linux}` — OS-specific additions layered on top by the host.

Every `default.nix` in this repo is an aggregator of imports; actual configuration lives in the per-program `.nix` files. To add a program, create a file in the right profile and add it to that profile's `default.nix`.

### The `rebuildCommand` convention

Each host passes its own rebuild command through `specialArgs`/`extraSpecialArgs` in `flake.nix` (or `hosts/pulsar/home.nix`), and `home/profiles/cli/aliases.nix` binds it to the `rebuild` shell alias. A new host must provide `rebuildCommand` or home-manager evaluation fails.

## Adding a new host

1. Create `hosts/<name>/` with a `home.nix` (and system config if NixOS).
2. Register it in `flake.nix` under `nixosConfigurations` or `homeConfigurations`, passing `inputs`, `self`, and `rebuildCommand`.
3. Import `home/dave` plus the appropriate `home/platforms/` directory, and set `home.homeDirectory`.
