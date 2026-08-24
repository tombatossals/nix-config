{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bandwhich # ancho de banda por proceso
    gping # ping con gráfica; comparar varios destinos a la vez
    iperf3 # medir throughput entre dos máquinas
    mtr # traceroute + ping continuo
    socat # redirecciones y sockets arbitrarios
    tcpdump # captura de paquetes
    trippy # traceroute moderno (TUI), complementa a mtr
    whois
  ];
}
