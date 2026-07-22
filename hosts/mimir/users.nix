{ pkgs, ... }:

{
  users.users.nixos = {
    isNormalUser = true;
    description = "NixOS";

    shell = pkgs.zsh;

    extraGroups = [
      "wheel"
    ];

    initialPassword = "perico";
  };
}
