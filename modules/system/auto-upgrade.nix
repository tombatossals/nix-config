{ ... }:

{
  # Actualización automática del sistema (sin reboot automático).
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    dates = "04:00";
  };
}
