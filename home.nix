{ config, pkgs, dgop, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    niri = "niri";
    alacritty = "alacritty";
    helix = "helix";
  };
in
{
  home.username = "jay";
  home.homeDirectory = "/home/jay";
  home.stateVersion = "25.11";
  home.sessionVariables = {
    EDITOR = "hx";
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "jayhwkns";
      email = "hawkinsjr27@gmail.com";
    };
  };
  
  programs.bash.enable = true;
  programs.dank-material-shell = {
    enable = true;
    dgop.package = dgop.packages.${pkgs.system}.default;
  };

  xdg.configFile = builtins.mapAttrs (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;

  home.packages = with pkgs; [
    helix
    nil
    ripgrep
    nixpkgs-fmt
    nodejs
    gcc
    cava
    cliphist
    wl-clipboard
    matugen
    anyrun
  ];

}
