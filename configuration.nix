# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, settings, ... }:
let
  # Creates a package that symlinks the plasma menu to the standard location
  kde-application-menu-fix = pkgs.runCommandLocal "xdg-application-menu" { } ''
    mkdir -p $out/etc/xdg/menus/
    ln -s ${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu $out/etc/xdg/menus/applications.menu
  '';
in {
  imports =
  [ # Include the results of the hardware scan.
    (if settings.laptop then ./hardware/laptop.nix else ./hardware/desktop.nix)
    ./steam.nix
    ./portal.nix
  ] ++ (if settings.laptop then [./laptop.nix] else []);

    # Allow unfree packages such as nvidia drivers
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

  services.udisks2.enable = true;

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
    extraGroups = [
      "wheel"
      "docker"
      "adbusers"
      "networkmanager"
    ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.fish = {
    enable = true;
  };
  users.users.jay.shell = pkgs.fish;

  programs.firefox.enable = true;

  environment.sessionVariables = {
    DISPLAY = "0";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.liberation
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


  # Docker
  virtualisation.docker.enable = true;

  # helpful for .NET
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    icu
  ];

  programs.niri.enable = true;

  # Garbage collector
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    helix
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    alacritty

    # Rust
    cargo
    rustc
    rust-analyzer
    
    pkg-config
    gdk-pixbuf
    pango
    cairo
    xwayland-satellite
    xrandr
    fish
    starship
    libsecret
    killall
    usbutils
    dotnet-sdk_9
    gtk3
    kde-application-menu-fix
    android-tools
    clang-tools
  ];
}

