# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "rainier";

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  programs.niri.enable = true;

  services.displayManager.ly = {
    enable = true;
    settings = {
      # leave the colors alone because the console doesn't support them all.
      animate = true;
      animation = "colormix";
      allow_empty_password = false;
      vi_mode = true;
      vi_default_mode = "insert";
    };
  };

  # GRAPHICS CONFIG
  hardware.graphics.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = false;
  hardware.graphics.enable32Bit = true;

  services.udisks2.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.accounts-daemon.enable = true;
  services.flatpak.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jay = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  programs.fish.enable = true;
  users.users.jay.shell = pkgs.fish;

  programs.firefox.enable = true;

  # needed for electron and chromium apps.
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    DISPLAY = "0";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    victor-mono
    nerd-fonts.victor-mono
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    57621 # spotify sync
  ];
  networking.firewall.allowedUDPPorts = [
    5353 # spotify sync
  ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "25.11"; 

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    helix
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    alacritty
    cargo
    pkg-config
    gdk-pixbuf
    pango
    cairo
    xwayland-satellite
    xrandr
    fish
    starship
    libsecret
  ];
}

