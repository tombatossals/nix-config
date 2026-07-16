{ ... }:

{
  imports = [
    ./boot.nix
    ./autologin.nix
    ./editors.nix
    ./gc.nix
    ./locale.nix
    ./networking.nix
    ./nix.nix
    ./zsh.nix
    ./packages.nix
    ./state-version.nix
    ./users.nix
  ];
}
