{ pkgs, inputs, ... }:
{
  # Steam config
  # NOTE: Many games will run better on Proton-GE than gamescope
  programs = {
    steam = {
      enable = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs: with pkgs; [
          libXcursor
          libXi
          libXinerama
          libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib # Provides libstdc++.so.6
          libkrb5
          keyutils
        ];
      };
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    gamemode.enable = true;
  };

  environment.sessionVariables = {
    PROTON_ENABLE_WAYLAND = "1";
  };
}
