{ ... }:

{
  imports = [
    ../../home/dave
    ../../home/platforms/linux
    ./red-casa.nix
    ./mikrotik-backup.nix
  ];

  home.username = "dave";
  home.homeDirectory = "/home/dave";
}
