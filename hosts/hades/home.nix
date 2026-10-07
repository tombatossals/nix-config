{ ... }:

{
  imports = [
    ../../home/dave
    ../../home/platforms/linux
    ./red-casa.nix
  ];

  home.username = "dave";
  home.homeDirectory = "/home/dave";
}
