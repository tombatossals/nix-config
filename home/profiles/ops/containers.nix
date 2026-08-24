{ pkgs, ... }:

# Los servicios de mimir corren como contenedores OCI de Podman
# (ver hosts/mimir/services/); esto es lo necesario para inspeccionarlos.
{
  home.packages = with pkgs; [
    dive # explorar capas de una imagen
    lazydocker # TUI; funciona contra Podman vía DOCKER_HOST
    podman-tui # TUI nativa de Podman
    skopeo # inspeccionar/copiar imágenes sin daemon
  ];
}
