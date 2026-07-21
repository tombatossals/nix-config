{ ... }:

{
  virtualisation.podman = {
    enable = true;

    # Alias `docker` -> podman y socket compatible con la API de Docker.
    dockerCompat = true;

    defaultNetwork.settings.dns_enabled = true;

    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };
}
