{ config, pkgs, ... }:

{
  users.users.dave = {
    isNormalUser = true;
    description = "David Rubert";

    shell = pkgs.zsh;

    extraGroups = [
      "wheel"
      "networkmanager"
    ];

    initialPassword = "perico";
  };
}
