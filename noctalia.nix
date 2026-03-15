{ pkgs, inputs, ... }:
{

  home-manager.users.jay = {
    # import the home manager module
    imports = [
      inputs.noctalia.homeModules.default
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
                labelMode = "none";
              }
            ];
            center = [
              {
                alwaysShowPercentage = false;
                id = "Battery";
                warningThreshold = 30;
              }
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
                id = "ControlCenter";
                useDistroLogo = true;
              }
              {
                id = "Network";
              }
              {
                id = "Bluetooth";
              }
            ];
          };
        };
        colorSchemes.predefinedScheme = "Kanagawa";
        general = {
          avatarImage = "/home/jay/.face";
          radiusRatio = 0;
        };
        location = {
          monthBeforeDay = true;
          name = "Houghton, MI";
        };
      };
    };
  };
}
