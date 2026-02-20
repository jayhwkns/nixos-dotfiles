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
  hardware.nvidia = {
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = true;
    nvidiaSettings = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
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
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
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

  # Steam config
  hardware.graphics.extraPackages = [ pkgs.gamescope ];
  programs = {
    steam = {
      enable = true;
      gamescopeSession = {
        enable = true;
        env = {
          WLR_RENDERER = "vulkan";
          DXVK_HDR = "1";
          ENABLE_GAMESCOPE_WSI = "1";
          WINE_FULLSCREEN_FSR = "1";
        };
        args = [
          "--output-width"
          "1920"
          "--output-height"
          "1080"
          "--steam"
          "--prefer-output"
          "DP-4"
        ];
      };
    };
    gamescope = {
      enable = true;
      capSysNice = true;
    };
  };

  # Docker
  # virtualisation.docker.enable = true;

  # helpful for .NET
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    icu
  ];

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
    niri
    killall
    usbutils
    dotnetCorePackages.sdk_9_0_1xx
  ];
}

