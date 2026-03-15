{ pkgs, inputs, ... }:
{
  # Steam config
  hardware.graphics.extraPackages = [ pkgs.gamescope ];
  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    gamescope = {
      enable = true;
      capSysNice = true;
    };
  };
}
