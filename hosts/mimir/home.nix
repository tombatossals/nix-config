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
      rebuildCommand = "sudo nixos-rebuild switch --flake ~/nix-config#mimir";
    };

    users.nixos = import ../../home/nixos;
  };
}
