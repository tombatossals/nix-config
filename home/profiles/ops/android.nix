{ pkgs, ... }:

# Herramientas para flashear dispositivos Android.
{
  home.packages = with pkgs; [
    heimdall # flasheo de firmware en dispositivos Samsung (modo Download / Odin)
  ];
}
