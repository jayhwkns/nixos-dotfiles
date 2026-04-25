{ pkgs, ... }:
{
  # Steam config
  # NOTE: Many games will run better on Proton-GE than gamescope
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;
      extraCompatPackages = [ pkgs.proton-ge-bin ];

      # Enable Steam Input for controller support
      package = pkgs.steam.override {
        extraPkgs =
          pkgs: with pkgs; [
            # Controller support libraries
            libusb1
            udev
            SDL2

            # Additional libraries for better compatibility (old names)
            # xorg.libXcursor
            libxcursor
            # xorg.libXi
            libxi
            # xorg.libXinerama
            libxinerama
            # xorg.libXScrnSaver
            libxscrnsaver
            # xorg.libXcomposite
            libxcomposite
            # xorg.libXdamage
            libxdamage
            # xorg.libXrender
            libxrender
            # xorg.libXext
            libxext

            # Fix for Xwayland symbol errors
            libkrb5
            keyutils
          ];
      };
    };
  };

  # System-level packages
  environment.systemPackages = with pkgs; [
    mangohud
  ];

  environment.sessionVariables = {
    PROTON_ENABLE_WAYLAND = "1";
  };

  services.xserver.enable = false;
}
