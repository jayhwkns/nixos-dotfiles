{ pkgs, ... }:
{
  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/spacemacs.yaml";

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
        package = pkgs.victor-mono;
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
    };
  };
}
