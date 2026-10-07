# Inventario de los MikroTik de la red de casa: nombre -> IP de gestión en
# admnet (VLAN 200). Es la única lista; de aquí salen los registros DNS
# <nombre>.mgmt.lan de Pi-hole (pihole.nix) y las copias diarias
# (mikrotik-backup.nix). El nombre coincide con la identidad del router.
{
  crs328 = "192.168.100.1";
  rb3011-comedor = "192.168.100.2";
  crs326 = "192.168.100.3";
  aire-acondicionado = "192.168.100.4";
  rb2011-garaje = "192.168.100.6";
  musica = "192.168.100.10";
  placas = "192.168.100.11";
  cap-garaje = "192.168.100.12";
  cap-paella = "192.168.100.13";
  "2011-uji" = "192.168.100.30";
  terraza = "192.168.100.15";
  comedor = "192.168.100.16";
  chimenea = "192.168.100.18";
  habitacion = "192.168.100.19";
  carlota = "192.168.100.20";
  nora = "192.168.100.21";
}
