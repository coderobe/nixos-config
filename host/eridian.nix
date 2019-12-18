{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration/eridian.nix
      ./core.nix
      ./hidpi.nix
    ];

  boot.kernelModules = [ "hid-microsoft" ];

  networking.hostName = "eridian";

  environment = {
    etc."NetworkManager/system-connections".source = "/persist/etc/NetworkManager/system-connections/";
    systemPackages = with pkgs; [
      btrfs-progs
      xournalpp
      gnome3.defaultIconTheme # Required for xournalpp
      steam
    ];
  };
}
