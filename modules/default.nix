{ ... }:

{
  imports = [
    ./system/boot.nix
    ./system/locale.nix
    ./system/networking.nix
    ./system/nix.nix
    ./system/state-version.nix
    ./system/users.nix

    ./services/openssh.nix
  ];
}
