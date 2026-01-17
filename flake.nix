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
    };

    outputs = { self, nixpkgs, dms, dgop, home-manager, ... }:
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
            ];
        };
    };
}
  	
