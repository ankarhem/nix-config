{
  description = "MacOS System Configuration flake";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs";
    };
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
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
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {self, ...}: let
    nixpkgsConfig = {
      config.allowUnfree = true;
    };
  in {
    darwinConfigurations = let
      inherit (inputs.darwin.lib) darwinSystem;
      inherit (inputs.nix-homebrew.darwinModules) nix-homebrew;
      inherit (inputs.home-manager.darwinModules) home-manager;

      username = "ankarhem";
      hostname = "ankarhem";
      system = "aarch64-darwin";
    in {
      "${hostname}" = darwinSystem {
        system = system;
        specialArgs = {inherit inputs username hostname;};
        modules = [
          ./hosts/darwin/nix.nix
          ./hosts/darwin/environment.nix
          ./hosts/darwin/user.nix
          ./hosts/darwin/settings.nix
          ./hosts/darwin/homebrew.nix
          nix-homebrew
          home-manager
          {
            nixpkgs = nixpkgsConfig;

            home-manager.extraSpecialArgs = {inherit inputs username hostname;};
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home;
          }
        ];
      };
    };
  };
}
