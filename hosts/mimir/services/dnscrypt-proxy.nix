{ ... }:
{
  # dnscrypt-proxy corre nativo (no en contenedor): así la configuración del
  # resolver es declarativa y vive en el flake, en vez de heredarse de lo que
  # traiga la imagen. La unidad de systemd que genera el módulo ya viene
  # endurecida (DynamicUser, ProtectSystem=strict, CacheDirectory).
  #
  # Escucha solo en loopback: el único cliente es Pi-hole, que corre en red
  # host y por tanto comparte el 127.0.0.1 de mimir.
  services.dnscrypt-proxy = {
    enable = true;

    # `settings` se fusiona (a nivel de clave de primer nivel) con el TOML de
    # ejemplo de upstream, que ya define bootstrap_resolvers, ignore_system_dns,
    # la caché y las fuentes de resolvers. Por eso aquí solo van los cambios.
    # OJO: la fusión es superficial, así que declarar `sources` parcialmente
    # sustituiría la tabla entera de upstream.
    settings = {
      listen_addresses = [ "127.0.0.1:5053" ];

      # Solo resolvers que validan DNSSEC y no registran las consultas.
      require_dnssec = true;
      require_nolog = true;
      require_nofilter = true;

      # La red de casa es IPv4; evitamos resolvers y respuestas AAAA inútiles.
      ipv4_servers = true;
      ipv6_servers = false;
    };
  };
}
