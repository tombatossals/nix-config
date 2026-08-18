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
    ./sudo.nix
    ./state-version.nix
    ./users.nix
  ];
}
