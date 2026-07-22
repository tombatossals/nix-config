{ ... }:

{
  disko.devices = {
    disk.main = {
      type = "disk";
      # SD del sistema (Raspberry Pi 4). Ruta estable por by-id.
      device = "/dev/disk/by-id/mmc-00000_0x23681456";

      content = {
        type = "gpt";

        partitions = {
          # Partición de firmware/arranque. En la Pi 4 el bootloader de la
          # EEPROM lee de aquí (start4.elf, config.txt, dtb) y U-Boot carga
          # la config de extlinux; por eso va en FAT32 y montada en /boot.
          firmware = {
            priority = 1;
            size = "512M";
            type = "0700"; # FAT / basic data (la Pi no usa ESP EF00)

            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };

          root = {
            size = "100%";

            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
