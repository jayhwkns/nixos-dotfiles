# I use syncthing to synchronize my music files.
# All it needs is to have both computers on and running syncthing at once
# (in the background)
{ ... }:
{
  # Protect with password if you ever decide to allow remote access
  services.syncthing = {
    enable = true;
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
}
