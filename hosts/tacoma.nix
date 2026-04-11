# Host-specific config for "tacoma" host, meaning my framework 13 laptop.
{ pkgs, ... }:
{
  networking.hostName = "tacoma";

  # firmware updating
  services.fwupd.enable = true;

  # battery
  services.power-profiles-daemon.enable = true;
  powerManagement.enable = true;
  services.upower.enable = true;

  # fingerprint
  services.fprintd.enable = true;

  environment.systemPackages = with pkgs; [
    acpi
  ];
}
