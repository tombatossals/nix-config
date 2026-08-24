{ pkgs, ... }:

# Herramientas para mantener este propio flake.
{
  home.packages = with pkgs; [
    alejandra # formateador; es el que ya usa lazyvim (ver lazyvim.nix)
    comma # ejecutar un binario sin instalarlo: , cowsay hola
    deadnix # detecta código Nix muerto
    nh # envoltorio de nixos-rebuild / home-manager con salida legible
    nix-diff # por qué difieren dos derivaciones
    nix-output-monitor # nom: árbol de construcción en vez de scroll infinito
    nix-tree # explorar el cierre de un paquete y su peso
    nvd # diff entre dos generaciones: qué paquetes suben o bajan
    statix # lint de antipatrones en Nix
  ];
}
