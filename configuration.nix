# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  secrets = import ./secrets.nix;
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };

  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = { 
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "hid-microsoft" ];
  };

  networking = {
    hostName = "eridian";
    networkmanager.enable = true;
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.wlp1s0.useDHCP = true;
  };

  powerManagement = { 
    powertop.enable = true;
    cpuFreqGovernor = "powersave";
  };

  environment = {
    etc."NetworkManager/system-connections".source = "/persist/etc/NetworkManager/system-connections/";
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    systemPackages = with pkgs;
    let
      nebula = with buildGoModule; buildGoModule rec {
      pname = "nebula";
      version = "1.0.0";
      src = fetchFromGitHub {
        owner = "slackhq";
        repo = pname;
        rev = "v${version}";
        sha256 = "0j7fna352z8kzx6n0hck7rp122c0v44j9syz0v30vq47xq2pwj5c";
      };
      modSha256 = "18k20s529fgsmns7d4paza9mawh8lli9hxsvvhs5xld25hf3zc4g";
      subPackages = [ "cmd/nebula" "cmd/nebula-cert" ];
      buildFlagsArray = [ "-ldflags='-X main.Build=${version}'" ];
    };
    in [
      btrfs-progs
      curl
      nano
      htop
      acpi
      chromium
      xournalpp
      gnome3.defaultIconTheme # Required for xournalpp
      openssh
      tmux
      mosh
      steam
      nebula
      ethtool
      iw
      git
      file
      testdisk
      pciutils
    ];
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "latarcyrheb-sun32";
    consoleKeyMap = "de-latin1";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable sound.
  sound.enable = true;
  hardware = {
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      tcp.enable = true;
      zeroconf.discovery.enable = true;
    };
    # Steam Controller
    steam-hardware.enable = true;
    # Scanning
    sane.enable = true;
    # Bluetooth
    bluetooth = {
      enable = true;
      package = pkgs.bluezFull;
      powerOnBoot = false;
    };
    # ucode
    cpu.intel.updateMicrocode = true;
  };

  services = {
    # Zeroconf
    avahi = {
      enable = true;
    };
    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      layout = "de";
      # Enable touchpad support.
      libinput.enable = true;
      # Enable a Desktop Environment.
      desktopManager.plasma5.enable = true;
    };
    # Enable CUPS to print documents.
    printing.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    root.initialHashedPassword = secrets.password_hash;
    coderobe = {
      uid = 1000;
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
      initialHashedPassword = secrets.password_hash;
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
