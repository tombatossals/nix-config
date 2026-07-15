{ config, pkgs, ... }:

{
  users.users.dave = {
    isNormalUser = true;
    description = "David Rubert";

    extraGroups = [
      "wheel"
      "networkmanager"
    ];

    initialPassword = "perico";
  };
}
