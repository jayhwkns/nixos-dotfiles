{
  description = "Flake based configuration for Jay's desktop";

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
      inputs.noctalia-qt.follows = "noctalia-qs";
    };
       niri = {
      url = "github:YaLTeR/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.rainier = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        # System configuration
        ./configuration.nix
        ./portal.nix
        # Home Manager
        inputs.home-manager.nixosModules.home-manager
        {
          inputs.home-manager = { 
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit niri;
            };
            users.jay = {
              imports = [
                ./home.nix
              ];
            };
            backupFileExtension = "backup";
          };
        }
        ./noctalia.nix
      ];
    };
  };
}
  	
