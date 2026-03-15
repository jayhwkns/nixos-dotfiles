# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let
  # Creates a package that symlinks the plasma menu to the standard location
  kde-application-menu-fix = pkgs.runCommandLocal "xdg-application-menu" { } ''
    mkdir -p $out/etc/xdg/menus/
    ln -s ${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu $out/etc/xdg/menus/applications.menu
  '';
in {
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
  virtualisation.docker.enable = true;

  # helpful for .NET
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    icu
  ];

  programs.adb.enable = true;

  programs.niri.enable = true;

  # Configure portal system-wide. Not in home!!!
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    configPackages = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    # Don't generate service files. We've done so below.
    config = {
      niri = {
        "org.freedesktop.portal.OpenURI" = "gnome";
        default = ["gnome" "gtk"];
      };
    };
  };
  # Enforce portal order for faster boot time
  systemd.user.services = {
    xdg-desktop-portal-gnome = {
      overrideStrategy = "asDropin";
      description = "Portal service (GNOME backend)";
      wantedBy = [ "graphical-session-pre.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "dbus.service" ];
      serviceConfig = {
        Type = "dbus";
        BusName = "org.freedesktop.impl.portal.desktop.gnome";
        Restart = "on-failure";
        RestartSec = "1";
        TimeoutStartSec = "10";
      };
    };

    xdg-desktop-portal-gtk = {
      overrideStrategy = "asDropin";
      description = "Portal service (GTK backend)";
      wantedBy = [ "graphical-session-pre.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "dbus.service" ];
      serviceConfig = {
        Type = "dbus";
        BusName = "org.freedesktop.impl.portal.desktop.gtk";
        Restart = "on-failure";
        RestartSec = "1";
        TimeoutStartSec = "10";
      };
    };

    xdg-desktop-portal = {
      overrideStrategy = "asDropin";
      description = "Portal service";
      wantedBy = [ "graphical-session.target" ];
      after = [ 
        "xdg-desktop-portal-gnome.service" 
        "xdg-desktop-portal-gtk.service" 
        "dbus.service" 
      ];
      requires = [ 
        "xdg-desktop-portal-gnome.service" 
        "xdg-desktop-portal-gtk.service" 
      ];
      
      serviceConfig = {
        Type = "dbus";
        BusName = "org.freedesktop.portal.Desktop";
        Restart = "on-failure";
        RestartSec = "1";
        TimeoutStartSec = "10";
        Environment = "XDG_DESKTOP_PORTAL_NO_RTKIT=1";
      };
    };
  };

  # Needed for git-credential-manger libsecret
  services.gnome.gnome-keyring.enable = true;

  # Garbage collector
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
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
    dotnetCorePackages.sdk_9_0_1xx
    gtk3
    kde-application-menu-fix
  ];
}

