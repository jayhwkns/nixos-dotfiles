{ config, pkgs, inputs, ... }:
{
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
}
