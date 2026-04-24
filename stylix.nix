{ pkgs, ... }:
{
  stylix = {
    enable = true;
    autoEnable = false;
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/spacemacs.yaml";
    base16Scheme = {
      # spacehawk dark
      base00 = "191616"; # Default Background
      base01 = "2f2a2c"; # Lighter background
      base02 = "94e2d5"; # Selection Background
      base03 = "707880"; # Comments
      base04 = "c7c7c7"; # Dark Foreground
      base05 = "e7e7e7"; # Default Foreground
      base06 = "f0f0f0"; # Light Foreground
      base07 = "383436"; # Light background
      base08 = "df7d00"; # Variables
      base09 = "be9cc1"; # Integers, booleans, constants
      base0A = "f64137"; # Classes, bold
      base0B = "61ad46"; # Strings
      base0C = "90dd78"; # Regex, escape characters
      base0D = "f9b955"; # Functions
      base0E = "b60109"; # Keywords
      base0F = "3b7cbc"; # Misc
    };

    fonts = {
      serif = {
        package = pkgs.nerd-fonts.liberation;
        name = "FreeSerif";
      };

      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat Light";
      };

      monospace = {
        package = pkgs.nerd-fonts.victor-mono;
        name = "VictorMono NF";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };

    # Only specify system-wide config here, otherwise put in home.nix
    targets = {
      fish.enable = true;
      gnome.enable = true;
      qt.enable = true;
      console.enable = true;
    };
  };
}
