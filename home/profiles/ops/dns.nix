{ pkgs, ... }:

# Diagnóstico de DNS. Relevante sobre todo para mimir, que es un resolutor
# (Pi-hole + dnscrypt-proxy + cloudflared) y hay que poder interrogar desde fuera.
{
  home.packages = with pkgs; [
    dnsutils # dig, nslookup, host
    doggo # cliente DNS moderno; habla DoH/DoT, útil para probar dnscrypt
  ];
}
