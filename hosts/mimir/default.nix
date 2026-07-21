{ inputs, ... }:

{
  imports = [
    inputs.agenix.nixosModules.default

    ./hardware-configuration.nix
    ./boot.nix
    ./users.nix
    ./home.nix
    ./services

    # Módulos de sistema genéricos (no importamos modules/system/default.nix
    # porque arrastra el usuario dave, su autologin y el arranque EFI de pulsar).
    ../../modules/system/auto-upgrade.nix
    ../../modules/system/editors.nix
    ../../modules/system/gc.nix
    ../../modules/system/locale.nix
    ../../modules/system/networking.nix
    ../../modules/system/nix.nix
    ../../modules/system/packages.nix
    ../../modules/system/state-version.nix
    ../../modules/system/sudo.nix
    ../../modules/system/zsh.nix

    ../../modules/services/openssh
    ../../modules/services/podman
  ];

  networking.hostName = "mimir";
}
