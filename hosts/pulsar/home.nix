{ inputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit inputs;
      rebuildCommand = "sudo nixos-rebuild switch --flake ~/nix-config#pulsar";
    };

    users.dave = import ../../home/dave;
  };
}
