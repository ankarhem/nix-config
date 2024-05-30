{
  description = "MacOS System Configuration flake";

  inputs = {
    nixpkgs = {
#      url = "github:nixos/nixpkgs/nixos-23.11";
     url = "github:nixos/nixpkgs/nixos-unstable";
    };
    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
#      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

    nixvim = {
      url = "github:nix-community/nixvim";
#      url = "github:nix-community/nixvim/nixos-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, ... }: let
    nixpkgsConfig = {
      config.allowUnfree = true;
    };
  in {
    darwinConfigurations = let 
      inherit (inputs.darwin.lib) darwinSystem;
      inherit (inputs.nix-homebrew.darwinModules) nix-homebrew;
      inherit (inputs.home-manager.darwinModules) home-manager;
      inherit (inputs.nixvim.nixDarwinModules) nixvim;
    in {
      ankarhem = darwinSystem {
	system = "aarch64-darwin";
	specialArgs = { inherit inputs; };
	modules = [
	  nix-homebrew
	  ./ankarhem/configuration.nix
	  home-manager
	  {
            nixpkgs = nixpkgsConfig;
            
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ankarhem = import ./ankarhem/home.nix;
          }
	  nixvim
	];
      };
    };
  };
}
