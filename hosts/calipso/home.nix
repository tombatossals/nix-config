{ ... }:

# calipso — Windows 11 Pro; home-manager standalone dentro de WSL2 (x86_64-linux).
{
  imports = [
    ../../home/dave
    ../../home/platforms/linux
  ];

  home.username = "dave";
  home.homeDirectory = "/home/dave";
}
