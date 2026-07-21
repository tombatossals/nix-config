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

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      pulsar = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";

        specialArgs = {
          inherit inputs self;
        };

        modules = [
          inputs.home-manager.nixosModules.home-manager

          ./hosts/pulsar
        ];
      };

      mimir = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";

        specialArgs = {
          inherit inputs self;
          host = "mimir";
        };

        modules = [
          inputs.home-manager.nixosModules.home-manager

          ./hosts/mimir
        ];
      };
    };

    homeConfigurations = {
      "dave@ares" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config = {
            allowUnfreePredicate = pkg:
              builtins.elem (nixpkgs.lib.getName pkg) [
                "oracle-instantclient"
              ];
            };
          };

        extraSpecialArgs = { 
          inherit inputs self;
          rebuildCommand = "nix run github:nix-community/home-manager/release-26.05 -- switch --flake ~/nix-config#dave@ares";
        };

        modules = [
          ./hosts/ares/home.nix
        ];
      };

      "vrubert@haddock" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config = {
            allowUnfreePredicate = pkg:
              builtins.elem (nixpkgs.lib.getName pkg) [
                "oracle-instantclient"
              ];
            };
          };

        extraSpecialArgs = {
          inherit inputs self;
          rebuildCommand = "nix run github:nix-community/home-manager/release-26.05 -- switch --flake ~/nix-config#vrubert@haddock";
        };

        modules = [
          ./hosts/haddock/home.nix
        ];
      };

      "dave@hades" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
        };

        extraSpecialArgs = {
          inherit inputs self;
          rebuildCommand = "nix run github:nix-community/home-manager/release-26.05 -- switch --flake ~/nix-config#dave@hades";
        };

        modules = [
          ./hosts/hades/home.nix
        ];
      };
    };

  };
}
