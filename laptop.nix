{ pkgs, ... }:
{
  # firmware updating
  services.fwupd.enable = true;
  services.power-profiles-daemon.enable = true;
  powerManagement.enable = true;
  services.upower.enable = true;

  environment.systemPackages = with pkgs; [
    acpi
  ];
}
