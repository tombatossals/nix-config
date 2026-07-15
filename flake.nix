{
  description = "NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ { nixpkgs, ... }: {
    nixosConfigurations = {
      pulsar = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";

        specialArgs = {
          inherit inputs;
          inherit (inputs) self;
        };

        modules = [
          ./hosts/pulsar
        ];
      };
    };
  };
}
