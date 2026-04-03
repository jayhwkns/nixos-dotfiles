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
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    # High-level custom settings passed to submodules for easy modification
    settings = {
      laptop = false;
    };
  in
  {
    nixosConfigurations.tacoma = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; inherit settings; };
      modules = [
        # System configuration
        ./configuration.nix
        ./portal.nix
        # Home Manager
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = { 
            useGlobalPkgs = true;
            useUserPackages = true;
            users.jay = {
              imports = [
                ./home.nix
              ];
            };
            backupFileExtension = "backup";
          };
        }
        # Desktop Shell
        ./noctalia.nix
      ] ++ (if settings.laptop then [
        # Framework hardware module
        inputs.nixos-hardware.nixosModules.framework-13-7040-amd
      ] else []) ;
    };
  };
}
  	
