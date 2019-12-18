{
  services = {
    xserver = {
      enable = true;
      layout = "de";
      # Enable touchpad support.
      libinput.enable = true;
      # Enable a Desktop Environment.
      desktopManager.plasma5.enable = true;
    };
  };
}
