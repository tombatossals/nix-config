{ inputs, ... }:

{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.disko.nixosModules.disko

    ./hardware-configuration.nix
    ./disko.nix
    ./boot.nix
    ./users.nix
    ./networking.nix
    ./home.nix
    ./services

    # Módulos de sistema genéricos (no importamos modules/system/default.nix
    # porque arrastra el usuario dave, su autologin y el arranque EFI de pulsar).
    ../../modules/system/auto-upgrade.nix
    ../../modules/system/editors.nix
    ../../modules/system/gc.nix
    ../../modules/system/locale.nix
    ../../modules/system/nix.nix
    ../../modules/system/packages.nix
    ../../modules/system/state-version.nix
    ../../modules/system/sudo.nix
    ../../modules/system/zsh.nix

    ../../modules/services/openssh
    ../../modules/services/podman
  ];
}
