{ config, lib, pkgs, ... }:
{
  virtualisation.oci-containers.containers."dnscrypt-proxy" = {
    image = "docker.io/klutchell/dnscrypt-proxy:latest";
    # No necesita puertos expuestos al exterior
    extraOptions = [
      "--network=dns_net"
      "--ip=10.10.10.3"
      "--label=io.containers.autoupdate=image"
    ];
  };
}
