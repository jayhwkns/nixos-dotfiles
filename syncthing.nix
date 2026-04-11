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
