{
    description = "Following NixOS Tutorial";
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/release-25.11";
        home-manager = {
            url = "github:nix-community/home-manager/release-25.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        dms = {
          url = "github:AvengeMedia/DankMaterialShell/stable";
          inputs.nixpkgs.follows = "nixpkgs";
        };
 
        dgop.url = "github:AvengeMedia/dgop";
        dgop.inputs.nixpkgs.follows = "nixpkgs";        

        # Use this version so we can use daemon
        anyrun.url = "github:anyrun-org/anyrun/v25.12.0"; 

        niri = {
            url = "github:YaLTeR/niri";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, dms, dgop, anyrun, home-manager, niri, ... }:
    let
        system = "x86_64-linux";
    in {
        nixosConfigurations.rainier = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
                ./configuration.nix
                home-manager.nixosModules.home-manager
                {
                home-manager = { 
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    extraSpecialArgs = {
                        inherit dgop;
                        inherit anyrun;
                    };
                    users.jay = {
                        imports = [
                            ./home.nix
                            dms.homeModules.dank-material-shell
                        ];
                    };
                    backupFileExtension = "backup";
                };
                }
                dms.nixosModules.dank-material-shell

                ({ pkgs, ... }: {
                    nixpkgs.overlays = [
                        (final: prev: {
                            niri = niri.packages.${system}.default;
                        })
                    ];
                })
            ];
        };
        homeConfigurations.user = home-manager.lib.homeManagerConfiguration {
            modules = [         
                ({ modulesPath, ...}: {
                    # disable anyrun's home-manager module to avoid redefinitions
                    disabledModules = ["${modulesPath}/programs/anyrun.nix"];
                })
                anyrun.homeManagerModules.default
                {
                    programs.anyrun.enable = true;
                }
            ];
        };
    };
}
  	
