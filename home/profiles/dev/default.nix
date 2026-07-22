{ ... }:

{
  imports = [
    ./direnv.nix
    ./database.nix
    ./cpp.nix
    ./go.nix
    ./herdr.nix
    ./node.nix
    ./python.nix
    ./rust.nix
    ./lazyvim.nix
    ./nginx.nix
  ];
}
