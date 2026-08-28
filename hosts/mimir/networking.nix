{ ... }:

{
  networking.hostName = "mimir";

  # mimir es un servidor DNS con IP fija: desactivamos DHCP y NetworkManager
  # para que no peleen con la configuración manual de abajo.
  networking.networkmanager.enable = false;
  networking.useDHCP = false;

  # IP estática en la interfaz cableada (end0). Pi-hole corre en red host, así
  # que sirve DNS en esta misma IP; networking.nameservers apunta aquí.
  networking.interfaces.end0.ipv4.addresses = [{
    address = "192.168.4.25";
    prefixLength = 24;
  }];

  networking.defaultGateway = "192.168.4.1";
  networking.nameservers = [ "192.168.4.25" "192.168.4.10" ];

  # ── Firewall ──────────────────────────────────────────────────────────────
  # El firewall de NixOS (nftables por debajo) es declarativo: se habilita y se
  # listan los puertos permitidos. Las listas de puertos se FUSIONAN con las de
  # otros módulos, así que aquí solo abrimos SSH; los puertos de DNS (53) y del
  # panel de Pi-hole (8888) los añade services/pihole.nix.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
}
