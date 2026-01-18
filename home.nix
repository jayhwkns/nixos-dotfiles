{ config, pkgs, dgop, anyrun, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    niri = "niri";
    alacritty = "alacritty";
    helix = "helix";
    dms = "dms";
    DankMaterialShell = "DankMaterialShell";
    zellij = "zellij";
  };
  anyrunCss = /*css*/ ''
      @define-color accent #8ea4a2;
      @define-color bg-color #181616;
      @define-color fg-color #c5c9c5;
      @define-color desc-color #a6a69c;

      window {
        background: transparent;
      }

      box.main {
        padding: 5px;
        margin: 10px;
        border-radius: 0;
        border: 2px solid @accent;
        background-color: rgba(24, 22, 22, 0.85);
        box-shadow: 0 0 5px black;
      }


      text {
        min-height: 30px;
        padding: 5px;
        border-radius: 0;
        color: @fg-color;
        font-family: "VictorMono NF";
      }

      .matches {
        background-color: rgba(0, 0, 0, 0);
        border-radius: 10px;
      }

      box, list, label {
        font-family: "VictorMono NF";
      }

      box.plugin:first-child {
        margin-top: 5px;
      }

      box.plugin.info {
        min-width: 200px;
      }

      list.plugin {
        background-color: rgba(0, 0, 0, 0);
      }

      label.match {
        color: @fg-color;
      }

      label.match.description {
        font-size: 10px;
        color: @desc-color;
      }

      label.plugin.info {
        font-size: 14px;
        color: @fg-color;
      }

      .match {
        background: transparent;
      }

      .match:selected {
        border-left: 4px solid @accent;
        background: transparent;
      }
    '';
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
  
  programs.fish = {
    enable = true;
    shellInit = /*bash*/ ''
      starship init fish | source
      set -g fish_key_bindings fish_vi_key_bindings
      set -U fish_greeting
    '';
  };
  programs.dank-material-shell = {
    enable = true;
    dgop.package = dgop.packages.${pkgs.system}.default;

    systemd = {
      enable = true;
      restartIfChanged = true;
    };
  };

  programs.anyrun = {
    enable = true;
    package = anyrun.packages.${pkgs.stdenv.hostPlatform.system}.anyrun-with-all-plugins;
    config = {
      x = { fraction = 0.5; };
      y = { fraction = 0.3; };
      width = { fraction = 0.3; };
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = false;
      closeOnClick = false;
      showResultsImmediately = false;
      maxEntries = null;

      plugins = [
        "${pkgs.anyrun}/lib/libapplications.so"
        "${pkgs.anyrun}/lib/libsymbols.so"
      ];
    };
    extraCss = anyrunCss;
  };

  gtk.gtk3.iconTheme = "Papirus-Dark";

  services.udiskie = {
    enable = true;
    settings = {
      program_options = {
        file_manager = "${pkgs.kdePackages.dolphin}/bin/dolphin";
      };
    };
  };

  # Create symlinks to app config directories
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
    gnome-font-viewer
    accountsservice
    zip
    unzip
    zellij
    kdePackages.dolphin
    flatpak
    discord
    # process viewer
    bottom
    bibata-cursors
    papirus-icon-theme
    steam
  ];
}
