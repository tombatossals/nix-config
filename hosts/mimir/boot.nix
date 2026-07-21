{ ... }:

{
  # La Raspberry Pi arranca con U-Boot + extlinux, no con systemd-boot/EFI.
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
}
