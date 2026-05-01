{ pkgs, colors, ... }:
{
  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = with colors.spacehawk_deep; {
      base00 = heatshield;
      base01 = light_heatshield;
      base02 = plume;
      base03 = spacecraft;
      base04 = light_spacecraft;
      base05 = fuselage;
      base06 = light_fuselage;
      base07 = white;
      base08 = nasa_red;
      base09 = mars;
      base0A = shuttle;
      base0B = earth;
      base0C = atmosphere;
      base0D = ocean;
      base0E = andromeda;
      base0F = lem;
      base10 = dark_heatshield;
      base11 = black;
      base12 = light_nasa_red;
      base13 = light_shuttle;
      base14 = light_earth;
      base15 = light_atmosphere;
      base16 = light_ocean;
      base17 = light_andromeda;
    };

    fonts = {
      serif = {
        package = pkgs.nerd-fonts.liberation;
        name = "FreeSerif";
      };

      sansSerif = {
        package = pkgs.public-sans;
        name = "Public Sans";
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
