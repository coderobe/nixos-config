{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "none";
      fsType = "tmpfs";
    };

  fileSystems."/nix" = 
    { device = "/dev/disk/by-uuid/85777659-6ea6-4628-b850-06db249a6f1a";
      fsType = "btrfs";
      options = [ "relatime" "subvol=store" "compress=zstd" ];
    };
  fileSystems."/etc/nixos" =
    { device = "/dev/disk/by-uuid/85777659-6ea6-4628-b850-06db249a6f1a";
      fsType = "btrfs";
      options = [ "relatime" "subvol=conf" "compress=zstd" ];
    };
  fileSystems."/persist" =
    { device = "/dev/disk/by-uuid/85777659-6ea6-4628-b850-06db249a6f1a";
      fsType = "btrfs";
      options = [ "relatime" "subvol=persist" "compress=zstd" ];
    };
  fileSystems."/root" =
    { device = "/dev/disk/by-uuid/85777659-6ea6-4628-b850-06db249a6f1a";
      fsType = "btrfs";
      options = [ "relatime" "subvol=homedirs/root" "compress=zstd" ];
    };
  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/85777659-6ea6-4628-b850-06db249a6f1a";
      fsType = "btrfs";
      options = [ "relatime" "subvol=homedirs" "compress=zstd" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/B3E6-A818";
      fsType = "vfat";
    };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 2;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  # High-DPI console
  i18n.consoleFont = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
}
