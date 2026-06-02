{ config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    niri = "niri";
    alacritty = "alacritty";
    helix = "helix";
    zellij = "zellij";
  };
in
{
  home.username = "jay";
  home.homeDirectory = "/home/jay";
  home.stateVersion = "25.11";
  home.sessionVariables = {
    EDITOR = "hx";
    QT_QPA_PLATFORM = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.cargo/bin"
  ];

  imports = [
    # Syncthing for music
    ./syncthing.nix
    ./anyrun.nix
    ./emulation.nix
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "jayhwkns";
        email = "hawkinsjr27@gmail.com";
      };
      init.defaultBranch = "main";
      credential.helper = "${
        pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
      push.autoSetupRemote = true;
      pull.rebase = true;
    };
  };
  
  programs.cargo = {
    enable = true;
  };

  programs.fish = {
    enable = true;
    shellInit = /*bash*/ ''
      starship init fish | source
      set -g fish_key_bindings fish_vi_key_bindings
      set -U fish_greeting
    '';
    shellAliases = {
      nix-shell = "nix-shell . --command fish";
    };
  };


  stylix.targets = {
    # noctalia-shell.enable = true;
    zellij.enable = true;
    kde.enable = true;
    starship.enable = true;
    blender.enable = true;
  };

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

  programs.obs-studio = {
    enable = true;

    package = (
      pkgs.obs-studio.override {
        cudaSupport = true;
      }
    );

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-gstreamer
      obs-vkcapture
    ];
  };

  home.packages = with pkgs; [
    helix
    nil
    ripgrep
    nixpkgs-fmt
    nodejs
    anyrun
    cava
    cliphist
    wl-clipboard
    matugen
    gnome-font-viewer
    accountsservice
    zellij
    flatpak
    discord
    joplin-desktop
    freecad
    # process viewer
    bottom
    bibata-cursors
    steam

    typescript-language-server
    dprint
    vscode-json-languageserver
    eslint
    vscode-css-languageserver

    zoom-us
    gamemode
    python3
    gimp

    # KDE apps
    kdePackages.dolphin
    kdePackages.kio
    kdePackages.kio-extras
    kdePackages.filelight
    kdePackages.kdenlive

    # for pause/play/skip
    playerctl

    protonup-rs

    # archives
    zip
    unzip
    p7zip

    blender
    typst
    libreoffice
    javaPackages.compiler.temurin-bin.jre-11
    tinymist
    kdePackages.elisa
    spotube

    font-awesome
    roboto
    source-sans-pro
    source-sans
    typos
    anki
  ];
}
