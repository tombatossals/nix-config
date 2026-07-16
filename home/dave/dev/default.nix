{ ... }:

{
  imports = [
    ./direnv.nix
    ./database.nix
    ./cpp.nix
    ./go.nix
    ./node.nix
    ./python.nix
    ./rust.nix
  ];
}
