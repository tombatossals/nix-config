{ ... }:

let
  btrfsMountOptions = [
    "compress=zstd"
    "noatime"
  ];
in
{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/disk/by-id/virtio-5EA44C4B323C4F3FA11C";

      content = {
        type = "gpt";

        partitions = {
          ESP = {
            priority = 1;
            size = "1G";
            type = "EF00";

            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };

          swap = {
            size = "4G";

            content = {
              type = "swap";
            };
          };

          root = {
            size = "100%";

            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];

              subvolumes = {
                "@" = {
                  mountpoint = "/";
                  mountOptions = btrfsMountOptions;
                };

                "@home" = {
                  mountpoint = "/home";
                  mountOptions = btrfsMountOptions;
                };

                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = btrfsMountOptions;
                };

                "@log" = {
                  mountpoint = "/var/log";
                  mountOptions = btrfsMountOptions;
                };

                "@snapshots" = {
                  mountpoint = "/.snapshots";
                  mountOptions = btrfsMountOptions;
                };
              };
            };
          };
        };
      };
    };
  };
}
