{ ... }:

{
  # La Raspberry Pi arranca con U-Boot + extlinux, no con systemd-boot/EFI.
  # U-Boot vive en la partición FIRMWARE (la pone la imagen sd-card) y lee la
  # configuración de extlinux de /boot, que está dentro de la raíz ext4; por eso
  # aquí no hay nada que apunte a /boot/firmware.
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
}
