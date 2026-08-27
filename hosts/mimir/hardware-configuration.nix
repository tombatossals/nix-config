{ lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # La microSD viene grabada con la imagen oficial nixos-image-sd-card-*.img,
  # que deja el disco con tabla MBR y dos particiones etiquetadas: FIRMWARE
  # (vfat, con el firmware de la Pi 4 y U-Boot) y NIXOS_SD (ext4, la raíz, que
  # se expande al primer arranque). Montamos por etiqueta y NO usamos disko:
  # así regrabar la tarjeta y hacer `nixos-rebuild switch` es suficiente, sin
  # reparticionar ni tener que reponer a mano el firmware de la Pi.
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };

  # El firmware no hace falta en tiempo de ejecución (extlinux vive en /boot,
  # dentro del ext4), así que se monta sin bloquear el arranque.
  fileSystems."/boot/firmware" = {
    device = "/dev/disk/by-label/FIRMWARE";
    fsType = "vfat";
    options = [ "nofail" "noauto" ];
  };

  # El controlador MMC de la Pi va compilado en el kernel; el resto son los
  # módulos habituales para leer la raíz desde initrd si hiciera falta.
  boot.initrd.availableKernelModules = [ "xhci_pci" "usbhid" "mmc_block" "sdhci_iproc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
