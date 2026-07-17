{ ... }:

{
  imports = [
    ../../home/dave
    ../../home/platforms/darwin
  ];

  extraSpecialArgs = {
    inherit inputs self;

    rebuildCommand = "home-manager switch --flake ~/nix-config#dave@ares";
  };

  home.homeDirectory = "/Users/dave";
}
