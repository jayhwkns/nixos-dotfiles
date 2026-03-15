{ pkgs, inputs, ... }:
{
  home-manager.users.jay = {
    # import the home manager module
    imports = [
      inputs.noctalia.homeModules.default
    ];
    home.packages = [
      inputs.noctalia-qs.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    # configure options
    programs.noctalia-shell = {
      enable = true;
      settings = {
        # configure noctalia here
        bar = {
          density = "compact";
          position = "top";
          showCapsule = false;
          widgets = {
            left = [
              {
                hideUnoccupied = false;
                id = "Workspace";
                labelMode = "index";
              }
              {
                id = "MediaMini";
              }
            ];
            center = [
              {
                formatHorizontal = "HH:mm";
                formatVertical = "HH mm";
                id = "Clock";
                useMonospacedFont = true;
                usePrimaryColor = true;
              }
            ];
            right = [
              {
                id = "Tray";
              }
              {
                id = "NotificationHistory";
                maximumWidth = "312";
              }
              {
                id = "Brightness";
              }
              {
                id = "Bluetooth";
              }
              {
                id = "Network";
              }
              {
                alwaysShowPercentage = false;
                id = "Battery";
                warningThreshold = 30;
              }
              {
                id = "ControlCenter";
                useDistroLogo = true;
                enableColorization = true;
              }
            ];
          };
        };
        colorSchemes = {
          useWallpaperColors = true;
          generationMethod = "muted";
          schedulingMode = "location";
        };
        nightLight = {
          enabled = true;
          autoSchedule = true;
        };
        general = {
          avatarImage = "/home/jay/.face";
          radiusRatio = 0;
        };
        location = {
          monthBeforeDay = true;
          name = "Houghton, MI";
        };
        wallpaper = {
          transitionType = [ "pixelate" ];
        };
      };
    };
  };
}
