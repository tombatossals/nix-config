{ inputs, ... }:

{
  imports = [
    inputs.disko.nixosModules.disko

    ./hardware-configuration.nix
    ./disko.nix
    ./networking.nix

    ../../modules
  ];
}
