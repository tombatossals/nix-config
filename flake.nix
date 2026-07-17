{
  description = "NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    lazyvim-nix = {
      url = "github:pfassina/lazyvim-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      pulsar = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";

        specialArgs = {
          inherit inputs self;
          hostName = "pulsar";
          isNixOS = true;
        };

        modules = [
          inputs.home-manager.nixosModules.home-manager

          ./hosts/pulsar
        ];
      };
    };

    homeConfigurations = {
      "dave@ares" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
        };

        extraSpecialArgs = { 
          inherit inputs self;
          hostName = "ares";
          isNixOS = false;
        };

        modules = [
          ./hosts/ares/home.nix
        ];
      };
    };
  };
}
