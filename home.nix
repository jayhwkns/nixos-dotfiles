{ config, pkgs, dgop, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    niri = "niri";
    alacritty = "alacritty";
    helix = "helix";
    anyrun = "anyrun";
    dms = "dms";
    DankMaterialShell = "DankMaterialShell";
  };
in
{
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
    gnome-font-viewer
    accountsservice
    zip
    unzip
    zellij
    spotify
    kdePackages.dolphin
  ];

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

  gtk = {
    enable = true;
    theme.name = "adw-gtk3";
    cursorTheme.name = "Bibata-Modern-Ice";
    iconTheme.name = "GruvboxPlus";
  };
  
  programs.fish.enable = true;
  programs.dank-material-shell = {
    enable = true;
    dgop.package = dgop.packages.${pkgs.system}.default;

    systemd = {
      enable = true;
      restartIfChanged = true;
    };
  };

  # Create symlinks to app config directories
  xdg.configFile = builtins.mapAttrs (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;
}
