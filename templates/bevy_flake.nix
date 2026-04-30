{
  description = "A flake for Bevy projects";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # for faster building
    naersk.url = "github:nix-community/naersk";
    bevy_cli.url = "github:TheBevyFlock/bevy_cli";
  };

  outputs = { self, nixpkgs, naersk, bevy_cli }: let
    pkgs = nixpkgs.legacyPackages."x86_64-linux";
    naerskLib = pkgs.callPackage naersk {};
  in {
    devShells."x86_64-linux".default = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        pkg-config
      ];

      

      buildInputs = with pkgs; [
        # rust
        cargo
        rustc
        rustfmt
        clippy
        rust-analyzer

        udev
        alsa-lib
        vulkan-loader
        libxkbcommon
        libx11
        libxcursor
        libxi

        bevy_cli.packages."x86_64-linux".bevy
      ];

      env.RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
    };

    packages."x86_64-linux".default = naerskLib.buildPackage {
      src = ./.;
      buildInputs = [ pkgs.glib ];
      nativeBuildInputs = [ pkgs.pkg-config ];
    };
  };
}
