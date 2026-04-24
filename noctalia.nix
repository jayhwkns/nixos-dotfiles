{ pkgs, inputs, lib, ... }:
{
  home-manager.users.jay = {
    imports = [
      inputs.noctalia.homeModules.default
    ];
    home.packages = [
      inputs.noctalia-qs.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    programs.noctalia-shell = {
      enable = true;
      settings = {
        bar = {
          density = "compact";
          position = "top";
          showCapsule = false;
          contentPadding = 4;
          useSeparateOpacity = true;
          backgroundOpacity = lib.mkForce 0;
          widgets = {
            left = [
              {
                hideUnoccupied = false;
                id = "Workspace";
                labelMode = "index";
                showApplications = true;
                iconScale = 1.0;
              }
              {
                id = "MediaMini";
                maxWidth = 250;
                useFixedWith = true;
              }
            ];
            center = [
              {
                formatHorizontal = "HH:mm ddd, MMM dd";
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
                id = "SystemMonitor";
              }
              {
                id = "NotificationHistory";
                maximumWidth = "312";
              }
              {
                id = "Bluetooth";
              }
              {
                id = "Volume";
              }
              {
                id = "Network";
              }
              {
                alwaysShowPercentage = true;
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
          useWallpaperColors = false;
          schedulingMode = "location";
          syncGsettings = true;
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
        dock.enabled = false;
        idle = {
          enabled = true;
          screenOffTimeout = 600;
          # disable lock and suspend
          lockTimeout = 0;
          suspendTimeout = 0;
          fadeDuration = 1;
          screenOffCommand = "";
          lockCommand = "";
          suspendCommand = "";
          resumeScreenOffCommand = "";
          resumeLockCommand = "";
          resumeSuspendCommand = "";
          customCommands = "[]";
        };
      };
    };
  };
}
