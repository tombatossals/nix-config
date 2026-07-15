{ ... }:

{
  imports = [
    ./system/boot.nix
    ./system/locale.nix
    ./system/networking.nix
    ./system/nix.nix
    ./system/state-version.nix
    ./system/users.nix

    ./system/packages.nix
    ./system/editors.nix

    ./services/openssh.nix
  ];
}
