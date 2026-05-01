{
  description = "Flake based configuration for Jay's desktop and laptop";

  # Flake-sourced packages
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.noctalia-qs.follows = "noctalia-qs";
    };
    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:YaLTeR/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, stylix, ... }@inputs:
  {
    nixosConfigurations = {
      rainier = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          colors = import ./colors.nix;
        };
        modules = [
          # Styling
          stylix.nixosModules.stylix
          # System configuration
          ./system/configuration.nix
          ./hosts/rainier.nix
          # Hardware configuration
          ./hardware/desktop.nix
          # Home Manager
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = { 
              useGlobalPkgs = true;
              useUserPackages = true;
              users.jay = {
                imports = [
                  ./home/home.nix
                ];
              };
              backupFileExtension = "backup";
            };
          }
        ];
      };

      tacoma = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          colors = import ./colors.nix;
        };
        modules = [
          # Styling
          stylix.nixosModules.stylix
          # System configuration
          ./system/configuration.nix
          ./hosts/tacoma.nix
          # Hardware configuration
          ./hardware/laptop.nix
          ./laptop.nix
          # Home Manager
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = { 
              useGlobalPkgs = true;
              useUserPackages = true;
              users.jay = {
                imports = [
                  ./home/home.nix
                ];
              };
              backupFileExtension = "backup";
            };
          }
          # Framework hardware module
          inputs.nixos-hardware.nixosModules.framework-13-7040-amd
        ];
      };
    };
  };
}
  	
