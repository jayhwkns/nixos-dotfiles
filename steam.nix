{ pkgs, inputs, ... }:
{
  # Steam config
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
  };
}
