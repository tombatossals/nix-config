{ ... }:

# calipso — Windows 11 Pro; home-manager standalone dentro de WSL2 (x86_64-linux).
{
  imports = [
    ../../home/dave
    ../../home/platforms/linux
  ];

  # El usuario de la WSL es `nixos`; aun así se importa el punto de entrada
  # home/dave porque se quiere el mismo conjunto de perfiles que en hades.
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";
}
