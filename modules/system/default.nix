{ ... }:

{
  imports = [
    ./autologin.nix
    ./boot.nix
    ./editors.nix
    ./gc.nix
    ./locale.nix
    ./networking.nix
    ./nix.nix
    ./packages.nix
    ./sudo.nix
    ./state-version.nix
    ./users.nix
    ./zsh.nix
  ];
}
