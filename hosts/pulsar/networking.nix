{ ... }:

{
  imports = [
    ../../modules/system/networking.nix
  ];

  networking.hostName = "pulsar";
}
