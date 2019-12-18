{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration/bandit.nix
      ./core.nix
      ./hidpi.nix
    ];

  networking.hostName = "bandit";

  environment = {
    systemPackages = with pkgs; [
      btrfs-progs
      steam
    ];
  };
}
