# I use syncthing to synchronize my music files.
# All it needs is to have both computers on and running syncthing at once
# (in the background)
{ ... }:
{
  # NOTE: If you ever choose to use syncthing for anything more than music
  # PROTECT WITH PASSWORD.
  services.syncthing = {
    enable = true;
    group = "jmusic";
    user = "jay";
    dataDir = "/home/jay/Music";
    configDir = "/home/jay/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      devices = {
        "rainier" = { id = "4T5IUT6-MFXRAVF-ZT2WDLO-Q2BI2QI-H2BTY7R-UGXKHD3-IMBYCHU-QMG5LA6"; };
        "tacoma" = { id = "SXDBZD2-EDK6OM4-QHJKSGX-4XQXXGT-4M6GBLY-WYJL66W-ROYSIV5-GERI4QC"; };
      };
      folders = {
        "Music" = {
          path = "/home/jay/Music";
          devices = [ "rainier" "tacoma" ];
        };
      };
    };
  };

  # 8384 TCP for web UI. Only needed if accessing remotely
  # 22000 TCP/UDP for sync traffic
  # 21027 UDP for discovery
  networking.firewall.allowedTCPPorts = [
    # 8384
    22000
  ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];
}
